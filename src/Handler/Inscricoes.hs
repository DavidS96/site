{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Inscricoes where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

eventoCB = do
   rows <- runDB $ selectList [] [Asc EventoNome]
   optionsPairs $ 
      map (\r -> (eventoNome $ entityVal r, entityKey r)) rows

 --renderDivs
formInscricoes :: UsuarioId -> Form Inscricoes
formInscricoes userId = renderBootstrap $ (Inscricoes userId)
      <$> areq (selectField eventoCB) "" Nothing

    
getInscricoesR :: Handler Html
getInscricoesR = do
    Just nome <- lookupSession "_NOME"
    Just (Entity key _) <- runDB $ selectFirst [UsuarioNome ==. nome] []
    (widget,_) <- generateFormPost (formInscricoes key)
    msg <- getMessage
    defaultLayout $ 
         [whamlet|
             $maybe mensa <- msg 
                 <div>
                     ^{mensa}
            
             <h1>
                 Inscricao
            
             <form method=post action=@{InscricoesR}>
                 ^{widget}
                <input type="submit" value="Cadastrar">
         |]

postInscricoesR :: Handler Html
postInscricoesR = do 
    Just nome <- lookupSession "_NOME"
    Just (Entity key _) <- runDB $ selectFirst [UsuarioNome ==. nome] []

    
    ((result,_),_) <- runFormPost $ formInscricoes key
    case result of 
        FormSuccess inscricoes -> do 
            runDB $ insert $ inscricoes
            setMessage [shamlet|
                <div>
                    USUARIO INSCRITO
            |]
            redirect EventsR
        _ -> redirect HomeR

getInscritoR :: EventoId -> Handler Html
getInscritoR eventoid = do 
    sess <- lookupSession "_NOME"
    let sql = "SELECT ??,??,?? FROM evento \
          \ INNER JOIN inscricoes ON inscricoes.eventoid = evento.id \
          \ INNER JOIN usuario ON inscricoes.usuarioid = usuario.id \
          \ WHERE evento.id = ?"
    evento <- runDB $ get404 eventoid
    inscritos <- runDB $ rawSql sql [toPersistValue eventoid] :: Handler [(Entity Evento,Entity Inscricoes,Entity Usuario)]
    defaultLayout $ do 
        [whamlet|
            <header>
                <div class="container">
                    <a href=@{HomeR}>
                        <div id="logo">
            
                    <nav>
                        <ul>
                            <li>
                                <a href=@{HomeR}>Home
            
                            $maybe nomeSess <- sess
                                <li class="current">
                                    <a href=@{EventsR}>Events
                            $nothing
                                <li class="current">
                                    <a href=@{SigninR}>Events
                    
                            <li>
                                <a href=@{RulesR}>Rules
                   
                            $maybe nomeSess <- sess
                                <li>
                                   <form class="txtbox" method=post action=@{LogoutR}>
                                      <input type="submit" value="Sign Out">
                            $nothing
                                <li>
                                    <a href=@{SigninR}>Sign in
            
            <div class="container">
                <h1>#{eventoNome evento}
                <p>#{show $ eventoData evento}
                <div id="fotoevento">
                
                <div class="darkbox">
                    
                        <p>#{eventoDescricao evento}
            
                <h1>
                    Lista de Inscritos
                <ul>
                    $forall (Entity _ _, Entity _ _, Entity _ usuario) <- inscritos
                        <li>#{usuarioNome usuario}
            <p>               
            <footer>
                <div class="container">
                    <p>PokeSquad LEAGUE &trade; | Grupo de Pokemon voltado sempre para as ultimas gerações, foca em entregar um 
                        modo novo de se jogar fora das convenções já estabelecidas por formatos como Smogon e VGC, oferecendo um
                        formato
                        menos competitivo e mais <i>for fun.
        |]
        toWidget $(luciusFile "templates/style.lucius")
        toWidget $(luciusFile "templates/events.lucius")
       
      
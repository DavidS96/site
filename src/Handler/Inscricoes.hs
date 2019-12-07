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
            
            redirect EventR
        _ -> redirect HomeR

getInscritoR :: EventoId -> Handler Html
getInscritoR eventoid = do 
    let sql = "SELECT ??,??,?? FROM evento \
          \ INNER JOIN inscricoes ON inscricoes.eventoid = evento.id \
          \ INNER JOIN usuario ON inscricoes.usuarioid = usuario.id \
          \ WHERE evento.id = ?"
    evento <- runDB $ get404 eventoid
    inscritos <- runDB $ rawSql sql [toPersistValue eventoid] :: Handler [(Entity Evento,Entity Inscricoes,Entity Usuario)]
    defaultLayout $ do 
        [whamlet|
            <h1>
                Lista De Inscritos Do #{eventoNome evento}
            <ul>
                $forall (Entity _ _, Entity _ _, Entity _ usuario) <- inscritos
                    <li>
                        #{usuarioNome usuario}
        |]
      
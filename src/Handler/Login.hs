{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ (,)
    <$> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing

getLoginR :: Handler Html
getLoginR = do 
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                ENTRAR
            
            <form method=post action=@{LoginR}>
                ^{widget}
                <input type="submit" value="Entrar">
        |]

postLoginR :: Handler Html
postLoginR = do 
    ((result,_),_) <- runFormPost formLogin
    case result of 
        FormSuccess ("root@root.com","root125") -> do 
            setSession "_NOME" "admin"
            redirect AdminR
        FormSuccess (email,senha) -> do 
           -- select * from usuario where email=digitado.email
           usuario <- runDB $ getBy (UniqueEmailAdm email)
           case usuario of 
                Nothing -> do 
                    setMessage [shamlet|
                        <div>
                            E-mail NAO ENCONTRADO!
                    |]
                    redirect LoginR
                Just (Entity _ usu) -> do 
                    if (usuarioSenha usu == senha) then do
                        setSession "_NOME" (usuarioNome usu)
                        redirect HomeR
                    else do 
                        setMessage [shamlet|
                            <div>
                                Senha INCORRETA!
                        |]
                        redirect LoginR 
        _ -> redirect HomeR

postLogoutR :: Handler Html 
postLogoutR = do 
    deleteSession "_NOME"
    redirect HomeR

getAdminR :: Handler Html
getAdminR = do 
    defaultLayout $ do
      toWidget $(luciusFile "templates/style.lucius")
        [whamlet|
    <header>
    <div class="container">
        <a href=@{HomeR}>
            <div id="logo">
        <nav>
            <ul>
                <li class="current">
                    <a href=@{HomeR}>Home
                <li>
                    <a href=@{EventsR}>Events
                <li>
                    <a href=@{RulesR}>Rules
                $maybe nomeSess <- sess
                    <li>
                       <form method=post action=@{LogoutR}>
                          <input type="submit" value="Sair">
                    <div>
                        Ola #{nomeSess}
                $nothing
                    <li>
                    <a href=@{SigninR}>Sign in       
                      

<div class="container">
    <h1>
        <span class="highlight">Eventos</span> Recentes
    <div id="slider">

<section id="boxes">
    <div class="container">
        <div class="box">
            <a href="https://discord.gg/bHEkvUM" target="_blank">
                <img src=@{StaticR discord_png}>

            <h3>Servidor do Discord
            <p>Conecte-se em nosso servidor para bater um papo enquanto batalha

        <div class="box">
            <a href="https://chat.whatsapp.com/FBx7SodScQH2KhQt39D4sv" target="_blank">
                <img src=@{StaticR whatsapp_png}>

            <h3>Grupo do Whatsapp
            <p>Entre em nosso grupo e participe de todos os eventos e encontrar batalhas

        <div class="box">
            <a href="https://www.facebook.com/PokeSquadLeague/" target="_blank">
                <img src=@{StaticR facebook_png}>

            <h3>Página no Facebook
            <p>Curta nossa página para sempre ficar ligado no que está por vir

<footer>
    <div class="container">
        <p>PokeSquad LEAGUE &trade; | Grupo de Pokemon voltado sempre para as ultimas gerações, foca em entregar um 
            modo novo de se jogar fora das convenções já estabelecidas por formatos como Smogon e VGC, oferecendo um
            formato
            menos competitivo e mais <i>for fun.
    
    |]
    
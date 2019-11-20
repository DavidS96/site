{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Ator where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

formUsu :: Form Ator
formUsu = renderBootstrap $ Ator 
    <$> areq textField "Nome: " Nothing
    <*> areq emailField "Nasc: " Nothing
  
getUsuarioR :: Handler Html
getUsuarioR = do 
    (widget,enctype) <- generateFormPost formUsu
    defaultLayout $ do 
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE Usuario
                
            <form method=post action=@{UsuarioR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postUsuarioR :: Handler Html
postUsuarioR = do 
    ((result,_),_) <- runFormPost formUsu
    case result of 
        FormSuccess usuario -> do 
            runDB $ insert usuario
            setMessage [shamlet|
                <h2>
                    USUARIO INSERIDO COM SUCESSO
            |]
            redirect UsuarioR
        _ -> redirect HomeR
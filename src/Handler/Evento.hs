{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Evento where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formEvento :: Form Evento 
formEvento = renderBootstrap $ Evento
    <$> areq textField "Nome: " Nothing
    <*> areq dayField  "data: " Nothing
    <*> areq textField "descricao: " Nothing

getEventoR :: Handler Html
getEventoR = do 
    (widget,_)<- generateFormPost formEvento
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE EVENTO
            
            <form method=post action=@{EventoR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postEventoR :: Handler Html
postEventoR = do 
    ((result,_) <- runFormPost formEvento
    case result of 
        FormSuccess Evento -> do 
            runDB $ insert Evento 
            setMessage [shamlet|
                <div>
                    Evento INCLUIDO
            |]
            redirect EventoR
        _ -> redirect HomeR


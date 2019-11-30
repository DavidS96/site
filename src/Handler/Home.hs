{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius
import Handler.Login (formLogin)
import Handler.Usuario (formUsu)

getHomeR ::Handler Html
getHomeR = do
    defaultLayout $ do
        $(whamletFile "templates/index.hamlet")
        --toWidget $(jsFile "templates/slick.min.js")
        --toWidget $(jsFile "templates/main.js")
        --addScript (StaticR slick_js)
        --addScript (StaticR main_js)
        toWidget $(luciusFile "templates/style.lucius")
        

getRulesR ::Handler Html
getRulesR = do
    defaultLayout $ do
         $(whamletFile "templates/rules.hamlet")
         toWidget $(luciusFile "templates/style.lucius")

getSigninR ::Handler Html
getSigninR = do
    (widgetL,_) <- generateFormPost formLogin
    (widgetC,enctype) <- generateFormPost formUsu
    defaultLayout $ do
         $(whamletFile "templates/signin.hamlet")
         toWidget $(luciusFile "templates/style.lucius")
         toWidget $(luciusFile "templates/signin.lucius")

getEventsR ::Handler Html
getEventsR = do
    defaultLayout $ do
         $(whamletFile "templates/events.hamlet")
         toWidget $(luciusFile "templates/style.lucius")
         toWidget $(luciusFile "templates/events.lucius")

getEventR ::Handler Html
getEventR = do
    defaultLayout $ do
         $(whamletFile "templates/event.hamlet")
         toWidget $(luciusFile "templates/style.lucius")
         toWidget $(luciusFile "templates/events.lucius")






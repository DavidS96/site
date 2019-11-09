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

getPage1R ::Handler Html
getPage1R = do
    defaultLayout $ do
        $(whamletFile "templates/page1.hamlet")
        toWidgetHead $(luciusFile "templates/page1.lucius")
        toWidgetHead $(juliusFile "templates/page1.julius")

getPage2R ::Handler Html
getPage2R = do
    defaultLayout $ do
        $(whamletFile "templates/page2.hamlet")

getHomeR ::Handler Html
getHomeR = do
    defaultLayout $ do
        $(whamletFile "templates/page3.hamlet")
        toWidgetHead $(luciusFile "templates/page3.lucius")
        toWidget $(juliusFile "templates/jquery.julius")
        toWidget $(juliusFile "templates/jquery-migrate.julius")
        toWidget $(juliusFile "templates/main.julius")
        toWidget $(juliusFile "templates/slick.min.julius")


-- getHomeR :: Handler Html
-- getHomeR = do 
--     defaultLayout $ do 
--         addStylesheet (StaticR css_bootstrap_css)
--         toWidgetHead [julius|
--             function ola(){
--                 alert("ola");
--             }
--         |]
--         toWidgetHead [lucius|
--             h1 {
--                 color : red;
--             }
--         |]
--         [whamlet|
--             <h1>
--                 OLA MUNDO!
            
--             <img src=@{StaticR sample_png}>
            
--             <button class="btn btn-danger" onclick="olaa">
--                 OLA
--         |]
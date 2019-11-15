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

instance Yesod App where
    defaultLayout contents = do
        PageContent title headTags bodyTags <- widgetToPageContent contents
        mmsg <- getMessage
        withUrlRenderer [hamlet|
            $doctype 5

            <html>
                <head>
                    <title>home{title}
                    ^{headTags}
                <body>
                    $maybe msg <- mmsg
                        <div #message>#{msg}
                    ^{bodyTags}
        |]

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
         
getTesteR ::Handler Html
getTesteR = do
    defaultLayout $ do
         $(whamletFile "templates/teste.hamlet")





-- getPage2R ::Handler Html
-- getPage2R = do
--     defaultLayout $ do
--         $(whamletFile "templates/page2.hamlet")

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
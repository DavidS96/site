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

getHomeR :: Handler Html
getHomeR = do 
    defaultLayout $ do 
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead [julius|
            function ola(){
                alert("ola");
            }
        |]
        toWidgetHead [lucius|
            h1 {
                color : red;
            }
        |]
        [whamlet|
            <h1>
                OLA MUNDO!
            
            <img src=@{StaticR Pikachu_jpg}>
            
            <button class="btn btn-danger" onclick="olaa">
                OLA
        |]
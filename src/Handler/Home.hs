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
        toWidgetHead [julius|
            function ola() {
                alert("OI");
            }
        |]
        toWidgetHead [cassius|
            h1 
                color : blue;
        |] 
        [whamlet|
            <h1>
                OI MUNDO!
            
            <button onclick="ola()">
                OK!
        |]
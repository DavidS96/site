{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    toWidgetHead [julius|
        function ola(){
            alert("ola");
        }
    |]
    toWidgetHead [lucius|
       h1{
           color : red;
           }
       }|]
       
       [whamlet|
       <h1>
            OLA MUNDO!
            
       <BUTTON ONCLICK="OLA()">
            OLA
        }|]
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module Foundation where

import Import.NoFoundation
import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Yesod.Core.Types     (Logger)

data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static 
    , appConnPool    :: ConnectionPool 
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }

mkYesodData "App" $(parseRoutesFile "config/routes")

instance Yesod App where
    makeLogger = return . appLogger
    
    authRoute _ = Just LoginR
    
    isAuthorized HomeR _ = return Authorized
    isAuthorized LoginR _ = return Authorized
    isAuthorized UsuarioR _ = return Authorized 
    isAuthorized RulesR _ = return Authorized
    isAuthorized SigninR _ = return Authorized
    isAuthorized EventoR _ = isAdmin
    isAuthorized EventsR _ = return Authorized
    isAuthorized InscricoesR _ = return Authorized
    isAuthorized (InscritoR _) _ = return Authorized
    isAuthorized (StaticR _) _ = return Authorized
    isAuthorized AdminR _ = isAdmin
    isAuthorized _ _ = isUsuario

isAdmin :: Handler AuthResult
isAdmin = do 
    sess <- lookupSession "_NOME"
    case sess of 
        Nothing -> return AuthenticationRequired
        Just "admin" -> return Authorized
        Just _ -> return $ Unauthorized "Nessessário Autorização"

isUsuario :: Handler AuthResult
isUsuario = do 
    sess <- lookupSession "_NOME"
    case sess of 
        Nothing -> return AuthenticationRequired
        Just _ -> return Authorized

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

instance HasHttpManager App where
    getHttpManager = appHttpManager
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Produto where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

formProduto :: Form Produto
formProduto = renderBootstrap $ Produto
    <$> areq textField "Nome: " Nothing 
    <*> areq doubleField "Preco: " Nothing 

getProdutoR :: Handler Html
getProdutoR = do
(widget,enctype) <- generateFormProduto
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
           $maybe mensa <- msg
              <div>
                 ^{mensa}
            <h1>
                CADASTRO DE PRODUTO
            <form method=post action=@{ProdutoR}>
                ^{widget}
        |]

postProdutoR :: Handler html
postProdutoR = do
    ((result,_),_) <- runFormPost formProduto
    case result of
      FormSucccess produto -> do
         runDB $ insert produto
         steMessage [shamlet|
            <h2>
                 PRODUTO INSERIDO COM SUCESSO
         |]
         redirect ProdutoR
      _ -> redirect HomeR
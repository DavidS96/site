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

-- renderDivs
formProduto :: Form Produto 
formProduto = renderBootstrap $ Produto 
    <$> areq textField "Nome: " Nothing
    <*> areq doubleField "Preco: " Nothing


getProdutoR :: Handler Html
getProdutoR = do 
    (widget,enctype) <- generateFormPost formProduto 
    defaultLayout $ do 
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE PRODUTOS
                
            <form method=post action=@{ProdutoR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postProdutoR :: Handler Html
postProdutoR = do 
    ((result,_),_) <- runFormPost formProduto
    case result of 
        FormSuccess produto -> do 
            runDB $ insert produto
            setMessage [shamlet|
                <h2>
                    PRODUTO INSERIDO COM SUCESSO
            |]
            redirect ProdutoR
        _ -> redirect HomeR

getListProdR :: Handler Html 
getListProdR = do 
    -- select * from Produto order by produto.nome
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    defaultLayout $ do 
        $(whamletFile "templates/produtos.hamlet")

postApagarProdR :: ProdutoId -> Handler Html
postApagarProdR pid = do 
    _ <- runDB $ get404 pid
    runDB $ delete pid
    redirect ListProdR
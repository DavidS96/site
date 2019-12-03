{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ (,)
    <$> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing

getLoginR :: Handler Html
getLoginR = do 
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                ENTRAR
            
            <form method=post action=@{LoginR}>
                ^{widget}
                <input type="submit" value="Entrar">
        |]

postLoginR :: Handler Html
postLoginR = do 
    ((result,_),_) <- runFormPost formLogin
    case result of 
        FormSuccess ("root@root.com","root125") -> do 
            setSession "_NOME" "admin"
            redirect AdminR
        FormSuccess (email,senha) -> do 
           -- select * from usuario where email=digitado.email
           usuario <- runDB $ getBy (UniqueEmailAdm email)
           case usuario of 
                Nothing -> do 
                    setMessage [shamlet|
                        <div>
                            E-mail NAO ENCONTRADO!
                    |]
                    redirect LoginR
                Just (Entity _ usu) -> do 
                    if (usuarioSenha usu == senha) then do
                        setSession "_NOME" (usuarioNome usu)
                        redirect HomeR
                    else do 
                        setMessage [shamlet|
                            <div>
                                Senha INCORRETA!
                        |]
                        redirect LoginR 
        _ -> redirect HomeR

postLogoutR :: Handler Html 
postLogoutR = do 
    deleteSession "_NOME"
    redirect HomeR

getAdminR :: Handler Html
getAdminR = do 
    defaultLayout [whamlet|
      <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" type="text/css" href="../css/slick.css">  
        <header>
    <div class="container">
        <a href=@{HomeR}>
            <div id="logo">

        <nav>
            <ul>
                <li>
                    <a href=@{HomeR}>Home
                <li>
                    <a href=@{EventsR}>Events
                <li class="current">
                    <a href=@{RulesR}>Rules
                <li>
                    <a href=@{SigninR}>Sign in

                
<div class="container">
    <article>
        <h2 class="highlight">Item Clause:</h2>
        <li>Só será permitido a repetição de um item uma vez.</li>
        <li>O jogador pode repetir item contanto que só repita o mesmo item uma vez e não haja outros itens
            repetidos
            em
            seu time, como por exemplo, dois leftovers e duas focus sash. A repetição deve se manter em apenas um
            item,
            sendo válido casos como 1 leftovers e 2 focus sash, porém só repetindo uma vez, tornando inválido casos
            como
            1 leftovers e 3 focus sash.</li>
        <li>Alguns itens serão considerados iguais, portanto se aplicando a regra, sendo eles: Choice Itens – Choice
            Band, Choice Scarf, Choice Specs.
            Super Berries – Wiki Berry, Iapapa Berry, Aguav Berry, Figy
            Berry e Mago Berry.
            Halves Damage – Babiri Berry, Charti Berry, Chilian Berry,
            Chople Berry, Coba Berry, Colbur Berry, Haban Berry, Kasib Berry, Kebia Berry, Occa Berry, Passcho
            Berry,
            Payapa Berry, Rindo Berry, Roseli Berry, Shuca Berry, Tanga Berry, Wacan Berry e Yache Berry.
            Heal by Turn – Leftovers, Black Sludge e Big Root.</li>

        <h2 class="highlight">Species Clause:</h2>
        <li>Não será permitido repetir a mesma espécie de Pokemon.</li>
        <li>Não será permitido utilizar mais de um Pokemon com o mesmo número da Pokedéx no mesmo time.</li>
        <li>A Pokedéx considerada será a Global, não a de cada Geração.</li>

        <h2 class="highlight">Status Move Clause:</h2>
        <li>Não será permitido o uso dos moves Psych Up, Dark Void, Acupressure, Metronome, Cosmic Power, Disable,
            Double Team, Minimize, Entrainment, Flash, Kinesis, Sand Attack, Smokesreen e Perish Song.</li>
        <li>Não será permitido os seguintes <span class="highlight">z-moves</span>: 
            Camouflage, Celebrate, Conversion, Detect, Flash, Forest’s Curse, Geomancy, Happy Hour, Hold Hands,
            Kinesis,
            Lucky Chant, Purify, Sand Attack, Sketch e Smokescreen.</li>

        <h2 class="highlight">Damage Move Clause:</h2>
        <li>Não será permitido o uso dos moves Burn Up, Horn Drill, Guillotine, Fissure e Sheer Cold.</li>
        <li>Não será permitido os seguintes <span class="highlight">z-moves</span>: 
            Nature's Madness, Last Resort e Clanging Scales.</li>

        <h2 class="highlight">Z-Move Clause:</h2>
        <p>Não será permitido o uso de qualquer z-move cujo respectivo z-crystal ainda não tenha sido obtido e
            registrado em seu Trainer Card.</p>
        <p>Esta regra se aplica aos z-crystals exclusivos também, baseado em seu Type.
            Os z-crystals que não são obtiveis por meio de Trial podem ser obtidos por meio de Grand Trial, portanto
            essa regra se aplica a todos os z-crystals.</p>

        <h2 class="highlight">Ability Clause:</h2>
        <p>Não será permitido o uso das habilidades Moody, Snow Cloak, Sand Veil e Power Construct.</p>

        <h2 class="highlight">Connection Clause:</h2>
        <p>Em caso de perda de Conexão, a Battle deverá ser rejogada do zero.</p>
        <p>Todos os Pokemon que tomaram dano ou foram derrubados deverão voltar independentemente do estado de seu HP.</p>

<footer>
    <div class="container">
        <p>PokeSquad LEAGUE &trade; | Grupo de Pokemon voltado sempre para as ultimas gerações, foca em entregar um
            modo novo de se jogar fora das convenções já estabelecidas por formatos como Smogon e VGC, oferecendo um
            formato
            menos competitivo e mais <i>for fun.
    |]
    
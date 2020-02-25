module Typename exposing
    ( Animal(..)
    , Bird
    , Dog
    , Dolphin
    , TypenameQuery
    , TypenameResponse
    , typename
    )

import GraphQL.Errors
import GraphQL.Helpers.Decode
import GraphQL.Operation
import GraphQL.Response
import Json.Decode


typename : GraphQL.Operation.Operation GraphQL.Operation.Query GraphQL.Errors.Errors TypenameQuery
typename =
    GraphQL.Operation.withQuery
        """query Typename {
animal {
... on Dog {
__typename
color
}
... on Dolphin {
__typename
color
}
... on Bird {
color
}
}
}"""
        Maybe.Nothing
        typenameQueryDecoder
        GraphQL.Errors.decoder


type alias TypenameResponse =
    GraphQL.Response.Response GraphQL.Errors.Errors TypenameQuery


type alias TypenameQuery =
    { animal : Animal
    }


typenameQueryDecoder : Json.Decode.Decoder TypenameQuery
typenameQueryDecoder =
    Json.Decode.map TypenameQuery
        (Json.Decode.field "animal" animalDecoder)


type Animal
    = OnDog Dog
    | OnDolphin Dolphin
    | OnBird Bird


animalDecoder : Json.Decode.Decoder Animal
animalDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map OnDog dogDecoder
        , Json.Decode.map OnDolphin dolphinDecoder
        , Json.Decode.map OnBird birdDecoder
        ]


type alias Dog =
    { typename__ : String
    , color : String
    }


dogDecoder : Json.Decode.Decoder Dog
dogDecoder =
    Json.Decode.map2 Dog
        (Json.Decode.field "__typename" (GraphQL.Helpers.Decode.constantString "Dog"))
        (Json.Decode.field "color" Json.Decode.string)


type alias Dolphin =
    { typename__ : String
    , color : String
    }


dolphinDecoder : Json.Decode.Decoder Dolphin
dolphinDecoder =
    Json.Decode.map2 Dolphin
        (Json.Decode.field "__typename" (GraphQL.Helpers.Decode.constantString "Dolphin"))
        (Json.Decode.field "color" Json.Decode.string)


type alias Bird =
    { color : String
    }


birdDecoder : Json.Decode.Decoder Bird
birdDecoder =
    Json.Decode.map Bird
        (Json.Decode.field "color" Json.Decode.string)

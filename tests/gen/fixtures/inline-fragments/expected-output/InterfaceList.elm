module InterfaceList exposing
    ( Animal(..)
    , Bird
    , Dog
    , Dolphin
    , InterfaceListQuery
    , InterfaceListResponse
    , interfaceList
    )

import GraphQL.Errors
import GraphQL.Operation
import GraphQL.Response
import Json.Decode


interfaceList : GraphQL.Operation.Operation GraphQL.Operation.Query GraphQL.Errors.Errors InterfaceListQuery
interfaceList =
    GraphQL.Operation.withQuery
        """query InterfaceList {
animals {
... on Dog {
color
hairy
}
... on Dolphin {
color
fins
}
... on Bird {
canFly
color
}
}
}"""
        Maybe.Nothing
        interfaceListQueryDecoder
        GraphQL.Errors.decoder


type alias InterfaceListResponse =
    GraphQL.Response.Response GraphQL.Errors.Errors InterfaceListQuery


type alias InterfaceListQuery =
    { animals : List Animal
    }


interfaceListQueryDecoder : Json.Decode.Decoder InterfaceListQuery
interfaceListQueryDecoder =
    Json.Decode.map InterfaceListQuery
        (Json.Decode.field "animals" (Json.Decode.list animalDecoder))


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
    { color : String
    , hairy : Bool
    }


dogDecoder : Json.Decode.Decoder Dog
dogDecoder =
    Json.Decode.map2 Dog
        (Json.Decode.field "color" Json.Decode.string)
        (Json.Decode.field "hairy" Json.Decode.bool)


type alias Dolphin =
    { color : String
    , fins : Int
    }


dolphinDecoder : Json.Decode.Decoder Dolphin
dolphinDecoder =
    Json.Decode.map2 Dolphin
        (Json.Decode.field "color" Json.Decode.string)
        (Json.Decode.field "fins" Json.Decode.int)


type alias Bird =
    { canFly : Bool
    , color : String
    }


birdDecoder : Json.Decode.Decoder Bird
birdDecoder =
    Json.Decode.map2 Bird
        (Json.Decode.field "canFly" Json.Decode.bool)
        (Json.Decode.field "color" Json.Decode.string)

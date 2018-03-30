module InterfaceMultiple
    exposing
        ( InterfaceMultipleResponse
        , InterfaceMultipleQuery
        , Animal(..)
        , Mammal
        , Bird
        , interfaceMultiple
        )

import GraphqlToElm.Errors
import GraphqlToElm.Operation
import GraphqlToElm.Response
import Json.Decode


interfaceMultiple : GraphqlToElm.Operation.Operation GraphqlToElm.Operation.Query GraphqlToElm.Errors.Errors InterfaceMultipleQuery
interfaceMultiple =
    GraphqlToElm.Operation.withQuery
        """query InterfaceMultiple {
animal {
... on Mammal {
subclass
}
... on Bird {
color
canFly
}
}
}"""
        Maybe.Nothing
        interfaceMultipleQueryDecoder
        GraphqlToElm.Errors.decoder


type alias InterfaceMultipleResponse =
    GraphqlToElm.Response.Response GraphqlToElm.Errors.Errors InterfaceMultipleQuery


type alias InterfaceMultipleQuery =
    { animal : Animal
    }


interfaceMultipleQueryDecoder : Json.Decode.Decoder InterfaceMultipleQuery
interfaceMultipleQueryDecoder =
    Json.Decode.map InterfaceMultipleQuery
        (Json.Decode.field "animal" animalDecoder)


type Animal
    = OnBird Bird
    | OnMammal Mammal


animalDecoder : Json.Decode.Decoder Animal
animalDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map OnBird birdDecoder
        , Json.Decode.map OnMammal mammalDecoder
        ]


type alias Bird =
    { color : String
    , canFly : Bool
    }


birdDecoder : Json.Decode.Decoder Bird
birdDecoder =
    Json.Decode.map2 Bird
        (Json.Decode.field "color" Json.Decode.string)
        (Json.Decode.field "canFly" Json.Decode.bool)


type alias Mammal =
    { subclass : String
    }


mammalDecoder : Json.Decode.Decoder Mammal
mammalDecoder =
    Json.Decode.map Mammal
        (Json.Decode.field "subclass" Json.Decode.string)

module FragmentInFragmentPartial
    exposing
        ( Query
        , Animal
        , OnAnimal(..)
        , Mammal(..)
        , Dog
        , fragmentInFragmentPartial
        )

import GraphqlToElm.Graphql.Errors
import GraphqlToElm.Graphql.Operation
import GraphqlToElm.Helpers.Decode
import Json.Decode


fragmentInFragmentPartial : GraphqlToElm.Graphql.Operation.Operation GraphqlToElm.Graphql.Errors.Errors Query
fragmentInFragmentPartial =
    GraphqlToElm.Graphql.Operation.query
        """query FragmentInFragmentPartial {
animal {
color
... on Mammal {
... on Dog {
hairy
}
}
}
}"""
        Maybe.Nothing
        queryDecoder
        GraphqlToElm.Graphql.Errors.decoder


type alias Query =
    { animal : Animal
    }


queryDecoder : Json.Decode.Decoder Query
queryDecoder =
    Json.Decode.map Query
        (Json.Decode.field "animal" animalDecoder)


type alias Animal =
    { color : String
    , on : OnAnimal
    }


animalDecoder : Json.Decode.Decoder Animal
animalDecoder =
    Json.Decode.map2 Animal
        (Json.Decode.field "color" Json.Decode.string)
        onAnimalDecoder


type OnAnimal
    = OnMammal Mammal
    | OnOtherAnimal


onAnimalDecoder : Json.Decode.Decoder OnAnimal
onAnimalDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map OnMammal mammalDecoder
        , Json.Decode.succeed OnOtherAnimal
        ]


type Mammal
    = OnDog Dog
    | OnOtherMammal


mammalDecoder : Json.Decode.Decoder Mammal
mammalDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map OnDog dogDecoder
        , GraphqlToElm.Helpers.Decode.emptyObject OnOtherMammal
        ]


type alias Dog =
    { hairy : Bool
    }


dogDecoder : Json.Decode.Decoder Dog
dogDecoder =
    Json.Decode.map Dog
        (Json.Decode.field "hairy" Json.Decode.bool)

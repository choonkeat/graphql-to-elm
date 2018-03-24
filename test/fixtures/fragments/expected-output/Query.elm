module Query
    exposing
        ( FragmentsVariables
        , Query
        , User
        , Flip(..)
        , Heads
        , Tails
        , fragments
        )

import GraphqlToElm.Errors
import GraphqlToElm.Operation
import Json.Decode
import Json.Encode


fragments : FragmentsVariables -> GraphqlToElm.Operation.Operation GraphqlToElm.Errors.Errors Query
fragments variables =
    GraphqlToElm.Operation.query
        ("""query Fragments($id: String!) {
user1: user {
...fields
}
user2: user {
...fields
}
user3: userOrNull {
...fields
}
user4: userById(id: $id) {
...fields
}
flip {
...heads
... on Tails {
length
}
}
}"""
            ++ fields
            ++ heads
        )
        (Maybe.Just <| encodeFragmentsVariables variables)
        queryDecoder
        GraphqlToElm.Errors.decoder


fields : String
fields =
    """fragment fields on User {
id
name
email
}"""


heads : String
heads =
    """fragment heads on Heads {
name
}"""


type alias FragmentsVariables =
    { id : String
    }


encodeFragmentsVariables : FragmentsVariables -> Json.Encode.Value
encodeFragmentsVariables inputs =
    Json.Encode.object
        [ ( "id", Json.Encode.string inputs.id )
        ]


type alias Query =
    { user1 : User
    , user2 : User
    , user3 : Maybe.Maybe User
    , user4 : Maybe.Maybe User
    , flip : Flip
    }


queryDecoder : Json.Decode.Decoder Query
queryDecoder =
    Json.Decode.map5 Query
        (Json.Decode.field "user1" userDecoder)
        (Json.Decode.field "user2" userDecoder)
        (Json.Decode.field "user3" (Json.Decode.nullable userDecoder))
        (Json.Decode.field "user4" (Json.Decode.nullable userDecoder))
        (Json.Decode.field "flip" flipDecoder)


type alias User =
    { id : String
    , name : String
    , email : String
    }


userDecoder : Json.Decode.Decoder User
userDecoder =
    Json.Decode.map3 User
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "email" Json.Decode.string)


type Flip
    = OnHeads Heads
    | OnTails Tails


flipDecoder : Json.Decode.Decoder Flip
flipDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map OnHeads headsDecoder
        , Json.Decode.map OnTails tailsDecoder
        ]


type alias Heads =
    { name : String
    }


headsDecoder : Json.Decode.Decoder Heads
headsDecoder =
    Json.Decode.map Heads
        (Json.Decode.field "name" Json.Decode.string)


type alias Tails =
    { length : Float
    }


tailsDecoder : Json.Decode.Decoder Tails
tailsDecoder =
    Json.Decode.map Tails
        (Json.Decode.field "length" Json.Decode.float)
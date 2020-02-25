module SameTypeSameFieldsList exposing
    ( Person
    , Person2
    , Query
    , Response
    , query
    )

import GraphQL.Errors
import GraphQL.Operation
import GraphQL.Response
import Json.Decode


query : GraphQL.Operation.Operation GraphQL.Operation.Query GraphQL.Errors.Errors Query
query =
    GraphQL.Operation.withQuery
        """{
me {
bestFriend {
age
name
}
friends {
name
age
}
}
}"""
        Maybe.Nothing
        queryDecoder
        GraphQL.Errors.decoder


type alias Response =
    GraphQL.Response.Response GraphQL.Errors.Errors Query


type alias Query =
    { me : Person
    }


queryDecoder : Json.Decode.Decoder Query
queryDecoder =
    Json.Decode.map Query
        (Json.Decode.field "me" personDecoder)


type alias Person =
    { bestFriend : Maybe.Maybe Person2
    , friends : Maybe.Maybe (List (Maybe.Maybe Person2))
    }


personDecoder : Json.Decode.Decoder Person
personDecoder =
    Json.Decode.map2 Person
        (Json.Decode.field "bestFriend" (Json.Decode.nullable person2Decoder))
        (Json.Decode.field "friends" (Json.Decode.nullable (Json.Decode.list (Json.Decode.nullable person2Decoder))))


type alias Person2 =
    { age : Maybe.Maybe Int
    , name : String
    }


person2Decoder : Json.Decode.Decoder Person2
person2Decoder =
    Json.Decode.map2 Person2
        (Json.Decode.field "age" (Json.Decode.nullable Json.Decode.int))
        (Json.Decode.field "name" Json.Decode.string)

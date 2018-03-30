module DefaultScalarTypes
    exposing
        ( Response
        , Query
        , query
        )

import GraphqlToElm.Errors
import GraphqlToElm.Operation
import GraphqlToElm.Response
import Json.Decode


query : GraphqlToElm.Operation.Operation GraphqlToElm.Operation.Query GraphqlToElm.Errors.Errors Query
query =
    GraphqlToElm.Operation.withQuery
        """{
int
float
string
boolean
id
}"""
        Maybe.Nothing
        queryDecoder
        GraphqlToElm.Errors.decoder


type alias Response =
    GraphqlToElm.Response.Response GraphqlToElm.Errors.Errors Query


type alias Query =
    { int : Int
    , float : Float
    , string : String
    , boolean : Bool
    , id : String
    }


queryDecoder : Json.Decode.Decoder Query
queryDecoder =
    Json.Decode.map5 Query
        (Json.Decode.field "int" Json.Decode.int)
        (Json.Decode.field "float" Json.Decode.float)
        (Json.Decode.field "string" Json.Decode.string)
        (Json.Decode.field "boolean" Json.Decode.bool)
        (Json.Decode.field "id" Json.Decode.string)

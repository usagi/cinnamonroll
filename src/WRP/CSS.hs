module WRP.CSS (
  decompile, compile,
  to_wrpcss, to_css,
  parseCSS, parseWRPCSS
  ) where

import Text.Parsec
import Text.Parsec.String
import Data.List
import Data.Char

decompile :: String -> (Either ParseError String)
decompile a = case parseCSS a of
  Right a -> Right $ to_wrpcss a
  Left  a -> Left a

compile :: String -> (Either ParseError String)
compile a = case parseWRPCSS a of
  Right a -> Right $ to_css a
  Left  a -> Left a

to_wrpcss :: CSS -> String
to_wrpcss a = to_css a {--ToDo--}

to_css :: CSS -> String
to_css a = concatMap cinnamonroll_block_to_string a where
  cinnamonroll_block_to_string :: CSS_Cinnamonroll_Block -> String
  cinnamonroll_block_to_string a = name_to_string name ++ " " ++
                                   keys_to_string keys ++
                                   definitions_to_string definitions where
    name        = fst a
    keys        = fst $ snd a
    definitions = snd $ snd a
    name_to_string :: CSS_Cinnamonroll_Name -> String
    name_to_string [] = []
    name_to_string a  = "@" ++ a
    keys_to_string :: CSS_Cinnamonroll_Keys -> String
    keys_to_string [] = []
    keys_to_string a  = intercalate "," a
    definitions_to_string :: CSS_Definitions -> String
    definitions_to_string [] = ";\n"
    definitions_to_string a
      | name == [] = "\n" ++ (concatMap definition_to_string a) ++ "\n"
      | otherwise  = "{\n" ++ (concatMap definition_to_string a) ++ "}\n\n"
    definition_to_string :: CSS_Definition -> String
    definition_to_string a
      | selector a == [] = properties_to_string $ properties a
      | otherwise        = "  " ++ (selector a) ++ "{\n" ++ properties_to_string (properties a) ++ "  }\n"
    selector   a = fst a
    properties a = snd a
    properties_to_string :: CSS_Properties -> String
    properties_to_string a = concatMap property_to_string $ a where
      property_to_string :: CSS_Property -> String
      property_to_string a = "    " ++ name ++ ": " ++ value ++ ";\n" where
        name  = fst a
        value = snd a

type CSS = CSS_Cinnamonroll_Blocks

type CSS_Cinnamonroll_Blocks = [ CSS_Cinnamonroll_Block ]
type CSS_Cinnamonroll_Block  = ( CSS_Cinnamonroll_Name, ( CSS_Cinnamonroll_Keys, CSS_Cinnamonroll_Value ) )
type CSS_Cinnamonroll_Name   = String
type CSS_Cinnamonroll_Keys   = [ CSS_Cinnamonroll_Key ]
type CSS_Cinnamonroll_Key    = String
type CSS_Cinnamonroll_Value  = CSS_Definitions

type CSS_Definitions    = [ CSS_Definition ]
type CSS_Definition     = ( CSS_Selector, CSS_Properties )
type CSS_Selector       = String
type CSS_Properties     = [ CSS_Property ]
type CSS_Property       = ( CSS_Property_Name, CSS_Property_Value )
type CSS_Property_Name  = String
type CSS_Property_Value = String

parseCSS :: String -> (Either ParseError CSS)
parseCSS a = parse css "unknown" a

css :: Parser CSS
css = do
  skipMany ignores
  cinnamonroll_blocks

cinnamonroll_blocks :: Parser CSS_Cinnamonroll_Blocks
cinnamonroll_blocks = many cinnamonroll_block

cinnamonroll_block :: Parser CSS_Cinnamonroll_Block
cinnamonroll_block = do
  a <- lookAhead anyChar
  r <- case a of
    '@' -> do
        char '@'
        name  <- many $ noneOf " "
        keys  <- cinnamonroll_keys
        value <- try $ (char ';' >> return [])
             <|> case name of
                   "media" -> do
                     definitions
                   "page"  -> do
                     ps <- properties
                     return [ ( [], ps ) ]
                   _       -> return []
        return ( name, ( keys, value ) )
    _   -> do
        value <- definitions
        return ( [], ( [], value ))
  skipMany ignores
  return r

cinnamonroll_keys :: Parser CSS_Cinnamonroll_Keys
cinnamonroll_keys = sepBy cinnamonroll_key (char ',')

cinnamonroll_key :: Parser CSS_Cinnamonroll_Key
cinnamonroll_key = do
  skipMany ignores
  a <- many $ noneOf ",;{ "
  skipMany ignores
  return a

definitions :: Parser CSS_Definitions
definitions = do
  try $ char '{' <|> try (lookAhead anyChar)
  skipMany ignores
  a <- manyTill definition ( try (char '}') <|> lookAhead (char '@') )
  return a

definition :: Parser CSS_Definition
definition = do
  selector  <- many $ noneOf "{"
  ps        <- properties
  skipMany ignores
  return (selector, ps)

properties :: Parser CSS_Properties
properties = do
  skipMany ignores
  string "{"
  a <- manyTill property (try (char '}'))
  return a

property :: Parser CSS_Property
property = do
  skipMany ignores
  name  <- try (many1 $ noneOf ":")
  string ":"
  skipMany ignores
  value <- try (many1 $ noneOf ";}")
  try $ char ';' <|> try ( lookAhead $ char '}' )
  skipMany ignores
  return ( trim name, trim value )

ignores :: Parser String
ignores = try comment_block
      <|> try ( string "\n\r")
      <|> try ( string "\r"  )
      <|> try ( string "\n"  )
      <|> try ( string "\t"  )
      <|> try ( string " "   )

comment_block :: Parser String
comment_block = do
  a <- string "/*"
  b <- many $ noneOf "*/"
  c <- string "*/"
  return $ a ++ b ++ c

parseWRPCSS :: String -> (Either ParseError CSS)
parseWRPCSS a = parse wrpcss "unknown" a

wrpcss :: Parser CSS
wrpcss = return $ []

optimize :: CSS -> CSS
optimize a = a

trim :: String -> String
trim = f.f where
  f = reverse.dropWhile isSpace


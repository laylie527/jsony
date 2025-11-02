import jsony
import std/[tables, strutils]

block:
  # Not allowed unless key hooks are defined
  let t = {1: 100}.toTable
  const s = """{"1":100}"""
  doAssert not compiles((discard t.toJson))
  doAssert not compiles((discard s.fromJson(Table[int, int])))

proc toKeyHook*(v: int): string =
  $v

proc fromKeyHook*(k: string; v: var int) =
  v = k.parseInt

block:
  let t = {1: 100}.toTable
  const s = """{"1":100}"""
  doAssert t.toJson == s
  doAssert s.fromJson(Table[int, int]) == t

block:
  # invalid JSON is still invalid
  doAssertRaises(JsonError):
    discard """{1:100}""".fromJson(Table[int, int])

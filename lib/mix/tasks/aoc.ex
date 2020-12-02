defmodule Mix.Tasks.Aoc do
  use Mix.Task

  @shortdoc "Run advent of code via mix aoc <day> <part>"
  def run(args) do
    [day, part | rest] = args

    input = Input.getInput(2020, day)
    day = to_string(day) |> String.pad_leading(2, "0")
    module = String.to_atom("Elixir.AdventOfCode.Day" <> day)
    partFn = getPartFn(part)

    parsed = apply(module, :parseInput, [input])

    if Enum.member?(rest, "-b") do
      Benchee.run(%{part_1: fn -> apply(module, partFn, [parsed]) end})
    else
      answer = apply(module, partFn, [parsed])
      IO.puts("Answer: #{answer}")
      Submit.submit(answer, 2020, day, part)
    end
  end

  defp getPartFn(part) do
    case part do
      "1" -> :part1
      "2" -> :part2
    end
  end
end

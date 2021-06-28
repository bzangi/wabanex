defmodule Wabanex.IMCTest do
  use ExUnit.Case, async: true

  describe "calculate/1" do
    test "when file exists, returns data " do
      params = %{"filename" => "students.csv"}

      response = Wabanex.IMC.calculate(params)

      expected_response =
        {:ok,
             %{
               "Dani" => 23.437499999999996,
               "Diego" => 23.04002019946976,
               "Gabu" => 22.857142857142858,
               "Rafael" => 24.897060231734173,
               "Rodrigo" => 26.234567901234566
             }}

      assert response == expected_response
    end

    test "when file doesn't exist, returns an error " do
      params = %{"filename" => "chopp.csv"}

      response = Wabanex.IMC.calculate(params)

      expected_response =
        {:error, "Error while opening the file"}

      assert response == expected_response
    end
  end
end

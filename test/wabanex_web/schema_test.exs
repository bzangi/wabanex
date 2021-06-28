defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "When a valid id is given, returns user.", %{conn: conn} do
      params = %{name: "Bruno", email: "bruno@gugou.com", password: "123456",
      trainings: [%{start_date: "2021-06-27", end_date: "2021-08-27",
      exercises: [%{name: "triceps banco", youtube_video_url: "www.youtube.com", protocol_description: "regular", repetitions: "4x12"}]}]}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
      {
        getUser(id: "#{user_id}"){
          name
          email
          trainings{
            id
            startDate
            endDate
            exercises{
              name
              repetitions
              protocolDescription
              youtubeVideoUrl
            }
          }
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response = %{
        "data" => %{
          "getUser" => %{
            "email" => "bruno@gugou.com",
            "name" => "Bruno",
            "trainings" => []
          }
        }
      }

      assert response == expected_response
    end
  end

  describe "users mutations" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {name: "Mauro", email: "maurobruno@gugou.com", password:"123456"
          }){
            id
            name
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

        assert %{"data" => %{"createUser" => %{"id" => _id, "name" => "Mauro"}}} =  response
    end
  end
end

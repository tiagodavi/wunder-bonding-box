# Wunder (BoundingBox)

To run this app:

  * Install dependencies with `mix deps.get`
  * Run tests `mix test`
  * Run IEX `iex -S mix`
  * Run `Wunder.BoundingBox.execute("./source/pairs.csv", "./source/coordinates.csv")`

  * Load files in memory with `Wunder.Tracking.load("./source/pairs.csv")`
  * Get all bounding boxes in memory with `Wunder.Tracking.bounding_boxes()`
  * Execute matching with `Wunder.Tracking.execute(%{origin: {14.6346, 120.9899}, destination: {14.6364, 120.9917}})`
  * Get all previous matchings with `Wunder.Tracking.result()`

```
[
  %{

    box: %Envelope{
      max_x: "14.636650000000003",
      max_y: "120.99324000000004",
      min_x: "14.626190000000003",
      min_y: "120.98974000000004"
    },
    coord: %{x: "14.6346", y: "120.9899"}
  },
  %{
    box: %Envelope{
      max_x: "14.636650000000003",
      max_y: "120.99324000000004",
      min_x: "14.626190000000003",
      min_y: "120.98974000000004"
    },
    coord: %{x: "14.6364", y: "120.9917"}
  },
  %{
  box: %Envelope{
    max_x: "14.575309999999998",
    max_y: "120.98037",
    min_x: "14.574179999999998",
    min_y: "120.97977999999999"
  },
  coord: %{x: "14.5749", y: "120.9798"}
},
%{
  box: %Envelope{
    max_x: "14.636650000000003",
    max_y: "120.99324000000004",
    min_x: "14.626190000000003",
    min_y: "120.98974000000004"
  },
  coord: %{x: "14.6355", y: "120.9908"}
},
%{
    box: %Envelope{

      max_x: "14.613450000000002",
      max_y: "120.98806000000003",
      min_x: "14.612040000000002",
      min_y: "120.98648000000003"
    },
    coord: %{x: "14.6125", y: "120.988"}
  },
  %{
    box: %Envelope{
      max_x: "14.475110000000003",
      max_y: "121.00115999999998",
      min_x: "14.473830000000003",
      min_y: "120.99969999999999"
    },
    coord: %{x: "14.4743", y: "121.001"}
  },
  %{
    box: %Envelope{

      max_x: "14.59343",
      max_y: "120.97985000000001",
      min_x: "14.59234",
      min_y: "120.97901000000002"
    },
    coord: %{x: "14.5926", y: "120.9798"}
  },
  %{
    box: %Envelope{
      max_x: "14.51318",
      max_y: "120.99562",
      min_x: "14.51064",
      min_y: "120.99506000000001"
    },
    coord: %{x: "14.5126", y: "120.9956"}
  },
  %{
    box: %Envelope{

      max_x: "14.746730000000003",
      max_y: "120.97252",
      min_x: "14.745920000000003",
      min_y: "120.97217"
    },
    coord: %{x: "14.7462", y: "120.9724"}
  },
  %{
    box: %Envelope{
      max_x: "14.471230000000006",
      max_y: "120.99795999999999",
      min_x: "14.469610000000005",
      min_y: "120.99708999999999"
    },
    coord: %{x: "14.4704", y: "120.9971"}
  }
]
```

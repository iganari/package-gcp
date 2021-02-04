// https://github.com/knative/docs/blob/master/docs/serving/samples/hello-world/helloworld-go/helloworld.go
// https://qiita.com/nyamage/items/80ca5480baad8da581df


package main

import (
        "fmt"
        "log"
        "net/http"
        "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
        log.Print("helloworld: received a request")

        target := os.Getenv("TARGET")
        if target == "" {
                target = "World"
        }

        fmt.Fprintf(w, "Hello %s! from Cloud Run :)\n\n", target)

  u := r.URL
  fmt.Fprintf(w, "Your Path is %s\n", u.String())
  fmt.Fprintf(w, "Your RawQuery: %s\n\n", u.RawQuery)
  
    for key, values := range u.Query() {
    fmt.Fprintf(w, "Your Query Key: %s\n", key)
    for i, v := range values {
      fmt.Fprintf(w, "Your Query Value[%d]: %s\n", i, v)
    }
  }
  fmt.Fprintf(w, "\n\nBye ! ;)")

}


func main() {
        log.Print("helloworld: starting server...")

        http.HandleFunc("/", handler)

        port := os.Getenv("PORT")
        if port == "" {
                port = "8080"
        }

        log.Printf("helloworld: listening on port %s", port)
        log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}

package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"

	rice "github.com/GeertJohan/go.rice"
	"github.com/husobee/vestigo"
	"strings"
)

type SitePageData struct {
	CTA  string
	VirtualHost  string
	KatacodaHost string
	KatacodaUser string
}
type TrainingPageData struct {
	Site SitePageData
	Name  string
	Subcourse string
}

type ScenarioPageData struct {
	Site SitePageData
	Training TrainingPageData
	Name  string
}

var templates = template.New("").Funcs(templateMap)
var templateBox *rice.Box

func newTemplate(path string, fileInfo os.FileInfo, _ error) error {
	if path == "" {
		return nil
	}
        if fileInfo.Mode().IsDir() {
            return nil
        }
	templateString, err := templateBox.String(path)
	if err != nil {
		log.Panicf("Unable to parse: path=%s, err=%s", path, err)
	}
	templates.New(filepath.Join("templates", path)).Parse(templateString)
	return nil
}

func renderTemplate(w http.ResponseWriter, tmpl string, p interface{}) {
	err := templates.ExecuteTemplate(w, tmpl, p)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func getSiteData() SitePageData {
	return SitePageData{VirtualHost: "learn.crunchydata.com",CTA: os.Getenv("CTA"), KatacodaHost: os.Getenv("KATACODA_HOST"), KatacodaUser: os.Getenv("KATACODA_USER")}
}

func scenario(w http.ResponseWriter, r *http.Request) {
	pageData := ScenarioPageData{Name: vestigo.Param(r, "scenario"), Training: TrainingPageData{Name: vestigo.Param(r, "course"), Subcourse: vestigo.Param(r, "subcourse")}, Site: getSiteData()}
	renderTemplate(w, "templates/scenario.html", &pageData)
}

func index(w http.ResponseWriter, r *http.Request) {
	pageData := TrainingPageData{ Site: getSiteData()}
	renderTemplate(w, "templates/index.html", &pageData)
}

func course(w http.ResponseWriter, r *http.Request) {
	pageData := TrainingPageData{Name: vestigo.Param(r, "course"), Site: getSiteData()}
	renderTemplate(w, "templates/course.html", &pageData)
}

func subcourse(w http.ResponseWriter, r *http.Request) {
	pageData := TrainingPageData{Name: vestigo.Param(r, "course"), Subcourse: vestigo.Param(r, "subcourse"), Site: getSiteData()}
	renderTemplate(w, "templates/subcourse.html", &pageData)
}

func subcoursescenario(w http.ResponseWriter, r *http.Request) {
	pageData := ScenarioPageData{Name: vestigo.Param(r, "scenario"), Training: TrainingPageData{Name: vestigo.Param(r, "course"), Subcourse: vestigo.Param(r, "subcourse")}, Site: getSiteData()}
	renderTemplate(w, "templates/subcoursescenario.html", &pageData)
}

func trainingcourse(w http.ResponseWriter, r *http.Request) {
	pageData := TrainingPageData{Name: "training/" + vestigo.Param(r, "course"), Site: getSiteData()}
	renderTemplate(w, "templates/course.html", &pageData)
}

func traininghome(w http.ResponseWriter, r *http.Request) {
	pageData := TrainingPageData{Name: "training", Site: getSiteData() }
	renderTemplate(w, "templates/course.html", &pageData)
}

func comingsoon(w http.ResponseWriter, r *http.Request) {
	pageData := TrainingPageData{Name: "comingsoon", Site: getSiteData() }
	renderTemplate(w, "templates/comingsoon.html", &pageData)
}

func trainingscenario(w http.ResponseWriter, r *http.Request) {
 	pageData := ScenarioPageData{Name: vestigo.Param(r, "scenario"), Site: getSiteData(), Training: TrainingPageData{Name: vestigo.Param(r, "course")}}
	renderTemplate(w, "templates/training-scenario.html", &pageData)
}

func redirectMiddleware(h http.HandlerFunc) http.HandlerFunc {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {

		if(req.URL.Scheme == "https" || req.Header.Get("x-forwarded-proto") == "https") {
			h.ServeHTTP(w, req)
		} else {
			target := "https://" + req.Host + req.URL.Path

			if len(req.URL.Query()) > 0 {
				for k, _ := range req.URL.Query() {
					if(string(k[0]) != ":") { //Remove vestigo parameters
						if(strings.Contains(target, "?") == false) {
							target += "?"
						} else {
							target += "&"
						}
						target += k + "=" + req.URL.Query().Get(k);
					}
				}
			}
			log.Printf("redirecting http %s to: %s", req.URL.Scheme, target)
			http.Redirect(w, req, target, http.StatusTemporaryRedirect)
		}
	})
}


func main() {
	var env = os.Getenv("ENV")
	templateBox = rice.MustFindBox("templates")
	templateBox.Walk("", newTemplate)

	router := vestigo.NewRouter()
	router.Get("/static/*", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))).ServeHTTP)

	if(env == "dev") {
		router.SetGlobalCors(&vestigo.CorsAccessControl{
			AllowOrigin: []string{"*"},
		})

		router.Get("/", index)
		router.Get("/:course", course)
		router.Get("/:course/", course)
		router.Get("/:course/courses/:subcourse", subcourse)
		router.Get("/:course/courses/:subcourse/", subcourse)
		router.Get("/comingsoon", comingsoon)
		router.Get("/comingsoon/", comingsoon)
		router.Get("/training", traininghome)
		router.Get("/training/", traininghome)
		router.Get("/training/:course", trainingcourse)
		router.Get("/training/:course/", trainingcourse)
		router.Get("/training/:course/:scenario", trainingscenario)
		router.Get("/:course/:scenario", scenario)
		router.Get("/:course/:scenario/", scenario)
		router.Get("/:course/courses/:subcourse/:scenario", subcoursescenario)
		router.Get("/:course/courses/:subcourse/:scenario/", subcoursescenario)

	} else {
		router.SetGlobalCors(&vestigo.CorsAccessControl{
			AllowOrigin: []string{"https://katacoda.com"},
		})
		
		router.Get("/", redirectMiddleware(index))
		router.Get("/:course", redirectMiddleware(course))
		router.Get("/:course/", redirectMiddleware(course))
		router.Get("/:course/courses/:subcourse", redirectMiddleware(subcourse))
		router.Get("/:course/courses/:subcourse/", redirectMiddleware(subcourse))
		router.Get("/comingsoon", redirectMiddleware(comingsoon))
		router.Get("/comingsoon/", redirectMiddleware(comingsoon))
		router.Get("/training", redirectMiddleware(traininghome))
		router.Get("/training/", redirectMiddleware(traininghome))
		router.Get("/training/:course", redirectMiddleware(trainingcourse))
		router.Get("/training/:course/", redirectMiddleware(trainingcourse))
		router.Get("/training/:course/:scenario", redirectMiddleware(trainingscenario))
		router.Get("/:course/:scenario", redirectMiddleware(scenario))
		router.Get("/:course/:scenario/", redirectMiddleware(scenario))
		router.Get("/:course/courses/:subcourse/:scenario", redirectMiddleware(subcoursescenario))
		router.Get("/:course/courses/:subcourse/:scenario/", redirectMiddleware(subcoursescenario))
	}

	http.Handle("/", router)
	log.Print("Listening on 0.0.0.0:3000...")
	log.Fatal(http.ListenAndServe("0.0.0.0:3000", nil))
}

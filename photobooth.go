package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/rocketlaunchr/https-go"
	"io"
	"log"
	"net/http"
	"os"
)

func JSONError(w http.ResponseWriter, err error) {
	fmt.Println(err)
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("X-Content-Type-Options", "nosniff")
	w.WriteHeader(500)
	json.NewEncoder(w).Encode(err.Error())
}

func hello(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		p := "./static" + r.URL.Path
		if p == "./static/" {
			p = "./static/index.html"
		}
		fmt.Println(p)
		http.ServeFile(w, r, p)
	case "POST":
		file, handler, err := r.FormFile("image.png")
		if err != nil {
			JSONError(w, err)
			return
		}
		defer file.Close()

		// copy example
		f, err := os.OpenFile("static/images/"+handler.Filename, os.O_WRONLY|os.O_CREATE, 0666)
		if err != nil {
			JSONError(w, err)
			return
		}
		defer f.Close()
		io.Copy(f, file)

		if r.URL.Path == "/s3" {
			err = AddFileToS3("static/images/image.png")
			if err != nil {
				JSONError(w, err)
				return
			}
		}
	default:
		fmt.Fprintf(w, "Sorry, only GET and POST methods are supported.")
	}
}

// AddFileToS3 will upload a single file to S3, it will require a pre-built aws session
// and will set file info like content type and encryption on the uploaded file.
func AddFileToS3(fileDir string) error {

	region, exists := os.LookupEnv("AWS_REGION")

	if !exists {
		return errors.New("Missing environement AWS_REGION")
	}

	bucket, exists := os.LookupEnv("AWS_BUCKET")

	if !exists {
		return errors.New("Missing environement AWS_BUCKET")
	}

	// Create a single AWS session (we can re use this if we're uploading many files)
	s, err := session.NewSession(&aws.Config{Region: aws.String(region)})
	if err != nil {
		return err
	}
	// Open the file for use
	file, err := os.Open(fileDir)
	if err != nil {
		return err
	}
	defer file.Close()

	// Get file size and read the file content into a buffer
	fileInfo, _ := file.Stat()
	var size int64 = fileInfo.Size()
	buffer := make([]byte, size)
	file.Read(buffer)

	// Config settings: this is where you choose the bucket, filename, content-type etc.
	// of the file you're uploading.
	_, err = s3.New(s).PutObject(&s3.PutObjectInput{
		Bucket:             aws.String(bucket),
		Key:                aws.String("/image.png"),
		ACL:                aws.String("private"),
		Body:               bytes.NewReader(buffer),
		ContentLength:      aws.Int64(size),
		ContentType:        aws.String(http.DetectContentType(buffer)),
		ContentDisposition: aws.String("attachment"),
	})
	return err
}

func main() {
	port, exists := os.LookupEnv("PHOTOBOOTH_PORT")
	if !exists {
		port = "443"
	}

	tls := true
	tls_value, exists := os.LookupEnv("DISABLE_TLS")
	if exists {
		fmt.Printf("DISABLE_TLS=%s. Will serve with HTTP Protocol ", tls_value)
		tls = false
	}

	http.HandleFunc("/", hello)

	fmt.Printf("Listening on %s\n", port)
	if tls {
		httpsServer, err := https.Server(port, https.GenerateOptions{Host: "photobooth.app"})
		if err != nil {
			log.Fatal(err)
		}
		err = httpsServer.ListenAndServeTLS("", "")
		if err != nil {
			log.Fatal(err)
		}
	} else {
		err := http.ListenAndServe(":"+port, nil)
		if err != nil {
			log.Fatal(err)
		}
	}
}

;; Scholar Network - Academic achievement tracking system for students
;; This contract manages student academic records and research contributions

;; Data storage for student information indexed by their blockchain identity
(define-map student-records
    principal  ;; Student's blockchain address
    {
        display-name: (string-ascii 100),              ;; Student's academic name
        graduation-year: uint,                         ;; Expected graduation year
        research-areas: (list 10 (string-ascii 50)),   ;; Fields of study and research interests
        publications: (list 5 (string-ascii 100)),     ;; Published papers and articles
        achievements: (list 5 (string-ascii 100))      ;; Academic awards and recognitions
    }
)

;; Error code definitions for better user feedback
(define-constant ERR-STUDENT-NOT-FOUND (err u404))      ;; Requested student record doesn't exist
(define-constant ERR-DUPLICATE-RECORD (err u409))       ;; Cannot create duplicate student records
(define-constant ERR-INVALID-YEAR (err u400))           ;; Graduation year validation failed
(define-constant ERR-INVALID-NAME (err u401))           ;; Display name validation failed
(define-constant ERR-INVALID-RESEARCH (err u402))       ;; Research areas validation failed
(define-constant ERR-INVALID-PUBLICATIONS (err u403))   ;; Publications validation failed
(define-constant ERR-INVALID-ACHIEVEMENTS (err u404))   ;; Achievements validation failed

;; Read-only helper function - Check if a student record exists
(define-read-only (record-exists? (student-id principal))
    (match (map-get? student-records student-id)
        record (ok true)  ;; Record found
        (ok false)        ;; No record found
    )
)

;; Read-only function - Get complete student record
(define-read-only (get-student-record (student-id principal))
    (match (map-get? student-records student-id)
        record (ok record)  ;; Return full academic record
        ERR-STUDENT-NOT-FOUND   ;; Record not in database
    )
)

;; Read-only function - Get student's display name
(define-read-only (get-student-name (student-id principal))
    (match (map-get? student-records student-id)
        record (ok (get display-name record))  ;; Extract just the name
        ERR-STUDENT-NOT-FOUND                  ;; Record not in database
    )
)

;; Read-only function - Get student's graduation year
(define-read-only (get-graduation-year (student-id principal))
    (match (map-get? student-records student-id)
        record (ok (get graduation-year record))  ;; Extract just the year
        ERR-STUDENT-NOT-FOUND                     ;; Record not in database
    )
)

;; Read-only function - Get student's research areas
(define-read-only (get-research-areas (student-id principal))
    (match (map-get? student-records student-id)
        record (ok (get research-areas record))  ;; Extract research interests
        ERR-STUDENT-NOT-FOUND                    ;; Record not in database
    )
)

;; Read-only function - Get student's publications
(define-read-only (get-publications (student-id principal))
    (match (map-get? student-records student-id)
        record (ok (get publications record))  ;; Extract publication list
        ERR-STUDENT-NOT-FOUND                  ;; Record not in database
    )
)

;; Read-only function - Get student's achievements
(define-read-only (get-achievements (student-id principal))
    (match (map-get? student-records student-id)
        record (ok (get achievements record))  ;; Extract achievement list
        ERR-STUDENT-NOT-FOUND                 ;; Record not in database
    )
)

;; Read-only function - Get count of publications
(define-read-only (count-publications (student-id principal))
    (match (map-get? student-records student-id)
        record (ok (len (get publications record)))  ;; Count publications
        ERR-STUDENT-NOT-FOUND                        ;; Record not in database
    )
)

;; Read-only function - Get count of achievements
(define-read-only (count-achievements (student-id principal))
    (match (map-get? student-records student-id)
        record (ok (len (get achievements record)))  ;; Count achievements
        ERR-STUDENT-NOT-FOUND                       ;; Record not in database
    )
)

;; Read-only function - Get summary of student academic statistics
(define-read-only (get-academic-summary (student-id principal))
    (match (map-get? student-records student-id)
        record (ok {
            display-name: (get display-name record),
            graduation-year: (get graduation-year record),
            research-count: (len (get research-areas record)),
            publications-count: (len (get publications record)),
            achievements-count: (len (get achievements record))
        })  ;; Return consolidated academic statistics
        ERR-STUDENT-NOT-FOUND  ;; Record not in database
    )
)

;; Public function - Create a new student record
(define-public (register-student 
    (display-name (string-ascii 100))
    (graduation-year uint)
    (research-areas (list 10 (string-ascii 50)))
    (publications (list 5 (string-ascii 100)))
    (achievements (list 5 (string-ascii 100))))
    (let
        (
            (student-id tx-sender)  ;; Current user's blockchain address
            (existing-record (map-get? student-records student-id))  ;; Check if record already exists
        )
        ;; First check if record already exists
        (if (is-none existing-record)
            (begin
                ;; Validate all input parameters
                (if (or (is-eq display-name "")
                        (< graduation-year u2020)          ;; Reasonable lower limit
                        (> graduation-year u2030)          ;; Reasonable upper limit
                        (is-eq (len research-areas) u0)    ;; Must have research interests
                        (is-eq (len publications) u0)      ;; Must have publications
                        (is-eq (len achievements) u0))     ;; Must have achievements
                    (err ERR-INVALID-YEAR)  ;; Return error if validation fails
                    (begin
                        ;; Store the validated student record
                        (map-set student-records student-id
                            {
                                display-name: display-name,
                                graduation-year: graduation-year,
                                research-areas: research-areas,
                                publications: publications,
                                achievements: achievements
                            }
                        )
                        (ok "Student record successfully created.")  ;; Success message
                    )
                )
            )
            (err ERR-DUPLICATE-RECORD)  ;; Cannot create duplicate record
        )
    )
)

;; Public function - Update an existing student record
(define-public (update-student-record
    (display-name (string-ascii 100))
    (graduation-year uint)
    (research-areas (list 10 (string-ascii 50)))
    (publications (list 5 (string-ascii 100)))
    (achievements (list 5 (string-ascii 100))))
    (let
        (
            (student-id tx-sender)  ;; Current user's blockchain address
            (existing-record (map-get? student-records student-id))  ;; Check if record exists
        )
        ;; First check if record exists
        (if (is-some existing-record)
            (begin
                ;; Validate all input parameters
                (if (or (is-eq display-name "")
                        (< graduation-year u2020)          ;; Reasonable lower limit
                        (> graduation-year u2030)          ;; Reasonable upper limit
                        (is-eq (len research-areas) u0)    ;; Must have research interests
                        (is-eq (len publications) u0)      ;; Must have publications
                        (is-eq (len achievements) u0))     ;; Must have achievements
                    (err ERR-INVALID-YEAR)  ;; Return error if validation fails
                    (begin
                        ;; Update the existing student record
                        (map-set student-records student-id
                            {
                                display-name: display-name,
                                graduation-year: graduation-year,
                                research-areas: research-areas,
                                publications: publications,
                                achievements: achievements
                            }
                        )
                        (ok "Student record successfully updated.")  ;; Success message
                    )
                )
            )
            (err ERR-STUDENT-NOT-FOUND)  ;; Cannot update non-existent record
        )
    )
)
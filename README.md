# Scholar Network - Clarity Smart Contract

## Overview

The **Scholar Network** smart contract is a decentralized academic achievement tracking system built using **Clarity** on the **Stacks blockchain**. It enables students and researchers to store and manage their academic records, research contributions, and scholarly achievements in a secure and immutable way.

## Features

- **Academic Record Management**: Create, update, and retrieve student academic profiles based on blockchain identity.
- **Research Portfolio Storage**: Store research areas, publications, and academic achievements.
- **Graduation Year Tracking**: Maintain expected graduation timelines for academic planning.
- **Comprehensive Error Handling**: Predefined error messages for robust validation.
- **Efficient Query Operations**: Fetch individual academic details or complete profile summaries.

## Smart Contract Details

### **Data Storage**
The contract maintains a `define-map` called `student-records`, which stores the following information:

| Field              | Type                                      | Description                                   |
|-------------------|-------------------------------------------|-----------------------------------------------|
| `display-name`    | `(string-ascii 100)`                     | Student's academic display name               |
| `graduation-year` | `uint`                                    | Expected graduation year                      |
| `research-areas`  | `(list 10 (string-ascii 50))`            | Fields of study and research interests        |
| `publications`    | `(list 5 (string-ascii 100))`            | Published papers and academic articles        |
| `achievements`    | `(list 5 (string-ascii 100))`            | Academic awards and recognitions              |

### **Functions**

#### ✅ **Read-Only Functions**
These functions allow users to retrieve academic data without modifying the blockchain state.

| Function Name           | Description |
|------------------------|-------------|
| `record-exists?`       | Checks if an academic record exists for the given student. |
| `get-student-record`   | Retrieves the complete academic profile of a student. |
| `get-student-name`     | Fetches only the student's display name. |
| `get-graduation-year`  | Fetches the student's expected graduation year. |
| `get-research-areas`   | Retrieves the student's research interests. |
| `get-publications`     | Gets the list of published academic works. |
| `get-achievements`     | Fetches academic awards and recognitions. |
| `count-publications`   | Counts the number of publications. |
| `count-achievements`   | Counts the number of academic achievements. |
| `get-academic-summary` | Returns a summary of the student's academic statistics. |

#### 🔄 **Public Functions**
These functions modify the state of the contract and require a blockchain transaction.

| Function Name           | Description |
|------------------------|-------------|
| `register-student`     | Creates a new academic record if none exists. |
| `update-student-record`| Updates an existing student's academic profile. |

### **Error Handling**
The contract defines several error messages for better debugging:

| Error Code                      | Meaning |
|--------------------------------|---------|
| `ERR-STUDENT-NOT-FOUND (u404)` | Academic record not found in the database. |
| `ERR-DUPLICATE-RECORD (u409)`  | A record already exists for this student. |
| `ERR-INVALID-YEAR (u400)`      | Invalid graduation year (outside 2020-2030 range). |
| `ERR-INVALID-NAME (u401)`      | Invalid display name format. |
| `ERR-INVALID-RESEARCH (u402)`  | Invalid research areas list. |
| `ERR-INVALID-PUBLICATIONS (u403)` | Invalid publications list. |

## How to Use

### **Deploying the Contract**
1. Ensure you have a working **Stacks CLI** and a **Clarity VM** setup.
2. Clone this repository:
   ```sh
   git clone https://github.com/your-username/scholar-network-contract.git
   cd scholar-network-contract
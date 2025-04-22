/*
## 🎯 **Problem Statement #2: Freelance Marketplace**

A platform connects freelancers with clients who post projects. Freelancers can browse available projects, submit proposals, get hired, and complete milestones. Clients can review freelancers after work completion.


### 🧩 Business Logic & Constraints

- Freelancers and clients both register on the platform with a unique email and a password (minimum 8 characters, must contain upper, lower, number).
  
- Every project has:
  - A title, description, budget (greater than 100), and a status (`Open`, `In Progress`, `Completed`, `Cancelled`).
  - A project must be marked `Completed` **only if all its milestones are marked completed**.
  - A project can only be posted by a verified client.

- Milestones:
  - Each project contains one or more milestones, each having a title, amount, and a due date.
  - Milestone amounts must **sum up to less than or equal to the project’s budget**.
  - A milestone can be marked as `Pending`, `Submitted`, or `Completed`.

- Freelancers can:
  - Submit only **one proposal per project**.
  - Only submit proposals for `Open` projects.
  - A proposal includes a cover letter, expected bid, and proposed timeline.

- Once a proposal is accepted:
  - The project is marked as `In Progress`, and the freelancer becomes associated with the project.
  - No other proposals can be accepted for that project.

- Clients can:
  - Only review freelancers **after the project is completed**.
  - A review must include a star rating between 1 and 5 and an optional text comment.
  - One client can leave only **one review per freelancer per project**.

- The platform tracks:
  - When proposals are submitted and updated.
  - When milestones are created and marked completed.
  - When a review is submitted.

*/

CREATE TABLE clients (
    client_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    client_name VARCHAR(30) NOT NULL CHECK (LENGTH(client_name) >= 3),
    client_email VARCHAR(30) NOT NULL UNIQUE CHECK (POSITION('@' IN client_email) > 0),
    client_password VARCHAR(16) NOT NULL CHECK (
        client_password ~ '^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,16}$'
    )
);

CREATE TABLE freelancers (
    freelancer_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    freelancer_name VARCHAR(30) NOT NULL CHECK (LENGTH(freelancer_name) >= 3),
    freelancer_email VARCHAR(30) NOT NULL UNIQUE CHECK (POSITION('@' IN freelancer_email) > 0),
    freelancer_password VARCHAR(16) NOT NULL CHECK (
        freelancer_password ~ '^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,16}$'
    )
);

CREATE TYPE project_status_enum AS ENUM('Open', 'In Progress', 'Completed', 'Cancelled');

CREATE TABLE projects (
    project_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    client_id INTEGER NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    project_title VARCHAR(60) NOT NULL CHECK (LENGTH(project_title) >= 5),
    project_description TEXT NOT NULL,
    project_budget NUMERIC(10, 2) NOT NULL CHECK (project_budget > 100),
    project_status project_status_enum NOT NULL
);

CREATE TABLE proposals (
    proposal_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    project_id INTEGER NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    freelancer_id INTEGER NOT NULL REFERENCES freelancers(freelancer_id) ON DELETE CASCADE,
    proposal_cover_letter TEXT NOT NULL,
    proposal_bid NUMERIC(10, 2) NOT NULL CHECK (proposal_bid > 0),
    proposal_deadline DATE NOT NULL CHECK (proposal_deadline::DATE > CURRENT_DATE),
    UNIQUE(project_id, freelancer_id)
);

CREATE TYPE milestone_status_enum AS ENUM('Pending', 'Submitted', 'Completed');

CREATE TABLE milestones (
    milestone_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    project_id INTEGER NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    milestone_title VARCHAR(60) NOT NULL CHECK (LENGTH(milestone_title) >= 5),
    milestone_budget NUMERIC(10, 2) NOT NULL CHECK (milestone_budget > 0),
    milestone_deadline DATE NOT NULL CHECK (milestone_deadline::DATE > CURRENT_DATE),
    milestone_status milestone_status_enum NOT NULL
);

CREATE TABLE reviews (
    review_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    client_id INTEGER NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    project_id INTEGER NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    freelancer_id INTEGER NOT NULL REFERENCES freelancers(freelancer_id) ON DELETE CASCADE,
    review_rating SMALLINT NOT NULL CHECK (review_rating BETWEEN 1 AND 5),
    review_comment TEXT,
    UNIQUE(client_id, project_id, freelancer_id)
);
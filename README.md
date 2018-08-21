# Issues Tracker API
## SETUP INSTRUCTIONS

There are 2 available versions of the setup:

Regular setup: `./bin/setup` ( *requires local ruby version* 2.5.1)

_**or**_

Docker setup: `./bin/docker-setup` ( *requires* docker *and* docker-compose *on your system* )

### Regular setup:
_**requirements:**_
You need to have ruby 2.5.1 installed. The `.ruby-version` takes care of setting
the right version if you have rbenv or rvm as your ruby version manager.
```bash
# rbenv
rbenv install 2.5.1
rbenv local 2.5.1

# rvm
rvm install 2.5.1
rvm use 2.5.1

# to check current version
ruby -v
which ruby
```
When that is resolved clone the git repository and run the setup as follows:
```bash
git clone https://github.com/khalilgharbaoui/issues-tracker-api.git
cd issues-tracker-api
./bin/setup
```

### Docker setup:

_**requirements:**_
You need to have `docker` and `docker-compose` installed and running on your system.
```bash
# install instructions comming soon...

```
When that is resolved clone the git repository and run the docker-setup as follows:
```bash
git clone https://github.com/khalilgharbaoui/issues-tracker-api.git
cd issues-tracker-api
./bin/docker-setup
```

## USAGE

#### Requirements:
You will need a *CLI tool* or REST *HTTP Client* like:

- HTTPie `brew install httpie` ( https://github.com/jakubroztocil/httpie )
- Postman ( https://www.getpostman.com/ )
- `Wget`
- `cURL`
- etc... ( ruby's `Net::HTTP` is also an option )

The app runs on `localhost` port `3000` ( http://localhost:3000 )

### **Authentication**

Each request is only authorized with an `Authorization` token.
When a user is created, after the `signup` the API responds with an `auth_token` token.

On each subsequent `login` the API responds with a new `auth_token` token.
The `auth_token` is only valid for a certain amount of time! (20 years in this app :P)

⚠️ If you want to make API requests you have to pass in your `auth_token` in the `Authorization` request Header field.

**NOTE:**
Some users and issues already exist!

User1 is not a manager.
To login and get a new token with User1 past this command in your terminal: (needs HTTPie)

`http POST http://localhost:3000/auth/login?email=user1@gmail.com&password=password1`

Or use this command in your terminal with the existing token: (needs HTTPie)
```bash
http GET :3000/issues \
Authorization:'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjIxNjQ3ODQ5MTd9.cGZHBZ6JdyjPGVIH7dBsQIr3BQAu7tlbZ_f4f5ggFGI'
```

Manager1 is a manager.
To login and get a new token with Manager1 past this command in your terminal: (needs HTTPie)

`http POST http://localhost:3000/auth/login?email=manager1@gmail.com&password=password1`

Or use this command in your terminal with the existing token: (needs HTTPie)

```bash
http GET :3000/issues \
Authorization:'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjIxNjQ3ODUyMzV9.a02R0yCL4I01NqDSRBomRJl_w-OReEr9SkXOYuboGKo'
```

To add and create your own users or managers and issues read below!

**Supported HTTP requests and examples are as the following:**

|**VERB**|**URL**|**PARAMETERS**|**MANDATORY?**|
|-|-|-|-|
| `GET` | `http://localhost:3000/issues`| **`page==2`** *and*/*or* **`status=pending`** | _optional_ |
| `GET` | `http://localhost:3000/issues/4` | ❌ | ❌ |
| `POST` | `http://localhost:3000/issues` | **`title="Awesome issue#1"`** | _mandatory_ |
| `PUT` | `http://localhost:3000/issues/3` | **`assigned_to=1`** *or* **`status=resolved`** | _mandatory_ ⚠️|
| `DELETE` | `http://localhost:3000/issues/2` | ❌ | ❌ |
| `POST` | `http://localhost:3000/auth/login` | **`email=manager1@gmail.com` `password=password1`** | _all mandatory_ |
| `POST` | `http://localhost:3000/signup` | **`name=NewManager1` `email=newuser1@gmail.com` `manager=true` `password=password1` `password_confirmation=password1`** | _all mandatory_ |

⚠️ To un-assigne an issue you have to add the **`assigned_to=`** param but _**with a blank value!**_

Also possible with postman see usage example #3 below.

### Examples:

❕**Example request #1:** Listing all pending issues with HTTPie:
```bash
http GET http://localhost:3000/issues status="pending" \
Authorization:'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjIxNjQ3ODUyMzV9.a02R0yCL4I01NqDSRBomRJl_w-OReEr9SkXOYuboGKo'
```

❕**Example request #2:** Get issues #21 with HTTPie:
```bash
http :3000/issues/21 Authorization:'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjIxNjQ3ODUyMzV9.a02R0yCL4I01NqDSRBomRJl_w-OReEr9SkXOYuboGKo'
```

I omitted the `GET` verb & the first part of the url `http://localhost`.
`GET` is the default for any request if no verb provided!
As long as i pass port `:3000` it knows how to look for the `localhost`. Awesome!

✅ This is the response:
```json
HTTP/1.1 200 OK
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json; charset=utf-8
ETag: W/"2219267c444574ed52df976c1ced7b5f"
Transfer-Encoding: chunked
X-Request-Id: 43f79a85-15aa-4538-ab0a-f39c98fa1dbd
X-Runtime: 0.006877

{
    "assigned_to": "",
    "created_at": "2018-08-08T00:49:37.636Z",
    "user_id": "1",
    "id": 21,
    "status": "pending",
    "title": "ISSUE #20 in",
    "updated_at": "2018-08-08T00:49:37.636Z"
}
```

❕**Example request #3:** Assigning and Unassigning manager #2 from/to issue #1 with Postman:**

![alt issue-tracker-api](http://g.recordit.co/I1Ezrm5Eac.gif "Assigning and Unassigning")

## DEPLOYMENT

`comming soon...`

## DEPENDENCIES
##### RUBY VERSION 2.5.1

  - active_model_serializers (~> 0.10.0)
  - bcrypt (~> 3.1.7)
  - bootsnap (>= 1.1.0)
  - database_cleaner
  - factory_bot_rails
  - faker
  - jwt
  - listen (>= 3.0.5, < 3.2)
  - pg
  - pry-rails
  - puma (~> 3.11)
  - rails (~> 5.2.0)
  - rspec-rails (~> 3.7)
  - seed_dump
  - shoulda-matchers (~> 3.1)
  - spring
  - spring-watcher-listen (~> 2.0.0)
  - tzinfo-data
  - will_paginate (~> 3.1.0)

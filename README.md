# Overview 

This Swift Package is the backend for a project that I have abandoned called FinanceFlow, and written in [Vapor](https://vapor.codes). 

This project was abandoned due to the expensive costs of Plaid, but the original app was to replace an existing budgeting application that I use on an almost daily basis, [EveryDollar](https://apps.apple.com/us/app/everydollar-personal-budget/id942571931)

## Features:
- Simple User Authentication via email & password
- Fetch banking institutions via Plaid API
- Fetch Transactions for connected banking institutions via Plaid API
- Upload budget and budget items to save in a Postgres Database

### Technical Overview:
- Utilized best security practices for User Authentication with protected routes for unauthenticated user's.
- Robust error handling and unit tests on all routes
- Dependency Injection with [Factory](https://github.com/hmlongco/Factory)
- FFAPI that contains the networking code, network models, and exposes a simple interface for communicating to the backend. 


### Further Discussion:
Overall this is a solid start to a full-stack application, and was built by me after going through a Vapor Udemy course. I learned a lot about databases, building a robust BFF (backend for front end), and enjoyed the ability to reuse the code and share the models that can be consumed by the host application. 

I look back on this project often, and will most likely use Vapor for my future needs as it pairs really well with iOS apps.

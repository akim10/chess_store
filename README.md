# chess_store
Final Project for 67-272: Application Design and Development

# To run the chess store:

1. Navigate to the folder in terminal.
2. Run 'bundle install' to install the gems used in this project
3. Run 'rake db:migrate'.
4. Run 'rake db:populate'.
5. Run 'rails server'
6. Go to 'localhost:3000' in your browser

Create an account to browse the site as a customer.

# To login as the different roles (shipper, manager, admin)

These account usernames are randomly generated so you will need to pull the list of users from the Rails console.

1. Navigate to the folder in terminal.
2. Run 'rails console'
3. Run 'Hirb.enable'
4. Run 'User.all'

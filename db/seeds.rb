# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Movie.create [
  {
    title: "Winter Sleep",
    rating: "PG",
    total_gross: 318412101.00,
    description: "If only Bergman were Turkish",
    released_on: "2014-06-13"
  },
  {
    title: "Leviathan",
    rating: "R",
    total_gross: 134218018.00,
    description: "Nowadays Tarkovsky in a Russian coastal town",
    released_on: "2015-02-05"
  },
  {
    title: "The Salt of the Earth",
    rating: "PG-13",
    total_gross: 403706375.00,
    description: "Very compelling doc about life, love, loss, despair and redemption",
    released_on: "2015-03-27"
  },
  {
    title: "Catwoman",
    rating: "PG-13",
    total_gross: 40200000.00,
    description: "Patience Philips has a more than respectable career as a graphic designer",
    released_on: "2004-07-23"
  }
]

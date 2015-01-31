# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Movie.create [
  {
    title: "Winter Sleep",
    rating: "PG",
    total_gross: 318412101.00,
    description: "If only Bergman were Turkish",
    released_on: 6.months.ago,
    cast: "Haluk Bilginer, Melisa Sözen, Demet Akba",
    director: "Nuri Bilge Ceylan",
    duration: "196 min",
    image_file_name: "wintersleep.jpg"
  },
  {
    title: "Leviathan",
    rating: "R",
    total_gross: 134218018.00,
    description: "Nowadays Tarkovsky in a Russian coastal town",
    released_on: 4.months.ago,
    cast: "Aleksey Serebryakov, Elena Lyadova, Roman Madyanov",
    director: " Andrey Zvyagintsev",
    duration: "140 min",
    image_file_name: "leviathan.jpg"
  },
  {
    title: "The Salt of the Earth",
    rating: "PG-13",
    total_gross: 403706375.00,
    description: "Very compelling doc about life, love, loss, despair and redemption",
    released_on: 1.month.from_now,
    cast: "Sebastião Salgado, Wim Wenders, Juliano Ribeiro Salgado",
    director: "Wim Wender and Juliano Ribeiro Salgado",
    duration: "110 min",
    image_file_name: "saltearth.jpg"
  },
  {
    title: "Catwoman",
    rating: "PG-13",
    total_gross: 40200000.00,
    description: "Patience Philips has a more than respectable career as a graphic designer",
    released_on: "2004-07-23",
    cast: "Halle Berry, Sharon Stone and Benjamin Bratt",
    director: "Jean-Christophe 'Pitof' Comar",
    duration: "101 min",
    image_file_name: "catwoman.jpg"
  }
]

def movie_attributes(override = {})
  {
    title: "Winter Sleep",
    rating: "PG",
    total_gross: 318412101.00,
    description: "If only Bergman were Turkish",
    released_on: "2014-06-13"
  }.merge(override)
end

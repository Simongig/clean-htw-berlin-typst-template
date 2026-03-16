#import "locale.typ": *

#let titlepage(
  authors,
  date,
  title-font,
  language,
  logo-left,
  logo-right,
  many-authors,
  supervisor,
  title,
  type-of-thesis,
  university,
  department,
  university-location,
  at-university,
  date-format,
  show-confidentiality-statement,
  confidentiality-marker,
  university-short,
  page-grid,
) = {

  // ---------- Page Setup ---------------------------------------
  set page(     
    // identical to document
    margin: (top: 4cm, bottom: 3cm, left: 4cm, right: 3cm),   
  )
  // The whole page in `title-font`, all elements centered
  set text(font: title-font, size: page-grid)
  set align(center)

  // ---------- Logo(s) ---------------------------------------

  if logo-left != none and logo-right == none {           // one logo: centered
    place(                                
      top + center,
      dy: -3 * page-grid,
      box(logo-left, height: 3 * page-grid) 
    )
  } else if logo-left != none and logo-right != none {    // two logos: left & right
    place(
      top + left,
      dy: -4 * page-grid,
      box(logo-left, height: 3 * page-grid) 
    )
    place(
      top + right,
      dy: -4 * page-grid,
      box(logo-right, height: 3 * page-grid) 
    )
  }

  // ---------- Title ---------------------------------------

  v(7 * page-grid)     
  text(weight: "bold", fill: cmyk(55%, 0%, 100%, 0%), size: 1.5 * page-grid, title)
  v(page-grid)
  
  // ---------- Confidentiality Marker (optional) ---------------------------------------

  if (confidentiality-marker.display) {
    let size = 7em
    let display = false
    let title-spacing = 2em
    let x-offset = 0pt

    let y-offset = if (many-authors) {
      7pt
    } else {
      0pt
    }

    if (type-of-degree == none and type-of-thesis == none) {
      title-spacing = 0em
    }

    if ("display" in confidentiality-marker) {
      display = confidentiality-marker.display
    }
    if ("offset-x" in confidentiality-marker) {
      x-offset = confidentiality-marker.offset-x
    }
    if ("offset-y" in confidentiality-marker) {
      y-offset = confidentiality-marker.offset-y
    }
    if ("size" in confidentiality-marker) {
      size = confidentiality-marker.size
    }
    if ("title-spacing" in confidentiality-marker) {
      confidentiality-marker.title-spacing
    }

    v(title-spacing)

    let color = if (show-confidentiality-statement) {
      red
    } else {
      green.darken(5%)
    }

    place(
      right,
      dx: 35pt + x-offset,
      dy: -70pt + y-offset,
      circle(radius: size / 2, fill: color),
    )
  }

  // ---------- Sub-Title-Infos ---------------------------------------
  // 
  // type of thesis (optional)
  align(center, text(size: page-grid, [Abschlussarbeit\ zur Erlangung des akademischen Grades:]))
  if (type-of-thesis != none and type-of-thesis.len() > 0) {
    align(center, text(size: page-grid, weight: "bold", type-of-thesis))
  }

  // university
  v(1em)
  text(university + [ ] + university-location)
  if department != none {
    linebreak()
    text(department)
  }

  // course of studies
  align(center, TITLEPAGE_SECTION_B.at(language) + authors.map(author => author.course-of-studies).dedup().join(" | "))


  // ---------- Supervisor(s) ---------------------------------------
  place(
    bottom + center,
    dy: -7 * page-grid,
    grid(
      columns: 2,
      column-gutter: 0.5em,
      row-gutter: 1em,
      align: left,
        // university supervisor
      ..if ("university" in supervisor) {
        (
          align(top, text(
            // weight: "bold", fill: luma(80), 
            TITLEPAGE_SUPERVISOR.at(language)
          )),
          if (type(supervisor.university) == str) {text(supervisor.university)}
        )
      },

      // company supervisor
      ..if ("company" in supervisor) {
        (
          align(top, text(
            // weight: "bold", fill: luma(80),
            
            TITLEPAGE_COMPANY_SUPERVISOR.at(language)
          )),
          if (type(supervisor.company) == str) {text(supervisor.company)}
        )
      },
    )
  )

  // ---------- Author(s) ---------------------------------------

  let columns = if (many-authors) {
    14pt
  } else {
    2
  }
  
  place(
    bottom + center,
    dy: -3 * page-grid,
    grid(
      columns: columns,
      gutter: if (many-authors) {
        14pt
      } else {
        0.5 * page-grid
      },
      AUTHOR_PRE.at(language) + [:],
      ..authors.map(author => align(
        center,
        {
          text(weight: "bold",author.name)
        },
      )),
    )
  )

  place(
    bottom + center,
    dy: -1 * page-grid,
    text(
      if (type(date) == datetime) {
        date.display(date-format)
      } else {
        date.at(0).display(date-format) + [ -- ] + date.at(1).display(date-format)
      },
    )
  )
}
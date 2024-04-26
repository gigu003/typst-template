
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#let report(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  univ_logo: "./_extensions/qcreport/logo1977.gif",
  registry: "肿瘤登记处",
  abstract: none,
  header: " ",
  footer: " ",
  cols: 1,
  margin: (x: 1.0in, y: 1.0in),
  paper: "a4",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  toc: false,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    fill: luma(250),
    numbering: "- 1 -",
    header: context {
      if counter(page).get().first() > 2 [
      #h(1fr)
      #text(size:11pt)[#header]
      ]
    },
    footer: context [
      #text(size:11pt)[#footer]
      #h(1fr)
      #text(size:11pt)[
      #counter(page).display(
        "1/1",
        both: true,
      )
      ]
      
    ]
  )
  
  set par(
          leading: 1.5em,
          justify: true,
          linebreaks: auto,
          first-line-indent: 2em,
    )
    
  set text(
    font: font,
    size: fontsize
    )

// 设置标题格式
set heading(numbering: sectionnumbering)
show heading: it => locate(loc => {
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
        levels.last()
    } else {
        1
    }

    set text(12pt)
    if it.level == 1 [
        #if deepest !=1 {
        }
        #set par(first-line-indent: 0pt)
        #let is-ack = it.body in ([Acknowledgment], [Acknowledgement])
        #set align(left)
        #set text(if is-ack { 15pt } else { 15pt },font:"SimHei")
        #v(36pt, weak: true)
        #if it.numbering != none and not is-ack {
        numbering("1.", deepest)
        h(7pt, weak: true)
        }
        #it.body
        #v(36pt, weak: true)
    ] else if it.level == 2 [
        #set par(first-line-indent: 0pt)
        #set text(size:14pt,font:"SimHei")
        #v(24pt, weak: true)
        #if it.numbering != none {
        numbering("1.1.",..levels)
        h(7pt, weak: true)
        }
        #it.body
        #v(24pt, weak: true)
    ] else if it.level == 3 [
        #set par(first-line-indent: 0pt)
        #set text(size:14pt,font:"SimHei")
        #v(15pt, weak: true)
        #if it.numbering != none {
        numbering("1.1.1.",..levels)
        h(7pt, weak: true)
        }
        #it.body
        #v(15pt, weak: true)
    ] else [
        #set par(first-line-indent: 0pt)
        #set text(size:12pt,font:"SimHei")
        #v(12pt, weak: true)
        #if it.numbering != none {
        numbering("1.1.1.1.",..levels)
        h(7pt, weak: true)
        }
        #it.body
        #v(12pt, weak: true) 
    ]
})


    
    
  align(center)[
    #image(univ_logo, height: 4cm)
    #block(inset: 0.5cm)[
    #text(size:15pt, fill:luma(80))[
      河南省癌症中心\
      河南省肿瘤登记处]
    ]
  ]

  if title != none {
    align(center)[#block(above: 2cm, below:2cm, height: 10%)[
      #text(weight: "bold", size: 30pt)[#title]
    ]]
  }
  if subtitle != none {
    align(center)[#block(above: 2cm, below:0cm, height: 5%)[
      #text(weight: "bold", size: 15pt)[#subtitle]
    ]]
  }

  align(center)[#line(length: 80%, stroke: 1.5pt + luma(80))]
  
  if registry != none {
    align(center)[#block(above:1cm, below:4cm, height:5%)[
      #text(weight: "bold", size: 15pt)[#registry]
    ]]
  }


  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 16pt,
      ..authors.map(author =>
          align(left)[
          #text(size:11pt)[
            编写: #author.name \
            单位: #author.affiliation \
            联系: #author.email
          ]
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 10pt)[
     #text(size: 12pt)[#date]
    ]]
  }

  pagebreak()

  if toc {
    block(above: 2em, below: 2em)[
    #set par(leading: 1.5em)
    #set text(size: 12pt)
    #align(center)[
     #outline(
      title: "主要内容",
      depth: 2,
      indent: auto,
    )
    ]
    ]
  }
  if toc {
    pagebreak()
  }

  
  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] \
    #h(1em) #abstract
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

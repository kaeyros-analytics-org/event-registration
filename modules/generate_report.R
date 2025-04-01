generate_report <- function(plot1,plot2,plot3,plot4,text1){
  # set_flextable_defaults(
  #   font.size = 8, font.family = 'Trebuchet MS',
  #   font.color = "#000000",
  #   table.layout = "fixed",
  #   border.color = "#000000",
  #   theme_fun = "theme_box",
  #   padding.top = 3, padding.bottom = 3,
  #   padding.left = 4, padding.right = 4,
  #   text.align = "right")
  
  # tab1<- flextable(tab1)
  # tab1 <- bg(tab1, j = 1, bg = "#f8cbdb", part = "all")
  # tab1<- bg(tab1, bg = "#808080", part = "header")
  # tab1<- bg(tab1, i=c(11,15),bg = "#D3D3D3")
  # tab1<- bg(tab1, i=16,bg = "#808080")
  # tab1 <- bold(tab1, i=c(11,16))
  # tab1<- bg(tab1, j=c(7,8),bg = "#ffffff")
  # tab1 <- color(tab1, i = ~ `Variation`<0, 
  #               j = ~ `Variation`, 
  #               color="red")
  # tab1 <- align(tab1, align = "right", part = "all")
  # tab1 <- autofit(tab1)
  
  text_style <- fp_text(font.size = 11,font.family = "Trebuchet MS")
  par_style <- fp_par(text.align = "justify",line_spacing = 1,)
  doc <- read_docx(path="./data/demande_congés.docx")
  #doc <- body_add_fpar(doc,fpar(ftext("Global report"),fp_p = fp_par(text.align = "center",line_spacing = 1,)))
  doc <- body_add_fpar(doc,
                       fpar(
                         ftext("Global report", prop = fp_text(font.size = 14, font.family = "Trebuchet MS", bold = TRUE)), # Titre avec style gras
                         fp_p = fp_par(text.align = "center", line_spacing = 1)
                       )
  )
  doc <- body_add_par(doc, " ")
  doc <- body_add_par(doc, " ")
  doc <- body_add_fpar(doc, fpar( ftext(text1, prop = text_style), fp_p = par_style ))
  doc <- body_add_par(doc, " ")
  doc <- body_add_fpar(doc,fpar(ftext("Number of cars per day"),fp_p = fp_par(text.align = "center",line_spacing = 1,)))
  doc <- body_add_gg(doc,plot1)
  doc <- body_add_break(doc)
  doc <- body_add_fpar(doc,fpar(ftext("Sales revenue per day"),fp_p = fp_par(text.align = "center",line_spacing = 1,)))
  doc <- body_add_gg(doc,plot2)
  doc <- body_add_break(doc)
  doc <- body_add_fpar(doc,fpar(ftext("Number of cars by category"),fp_p = fp_par(text.align = "center",line_spacing = 1,)))
  doc <- body_add_gg(doc,plot3)
  doc <- body_add_break(doc)
  doc <- body_add_fpar(doc,fpar(ftext("Sales revenue per category per day"),fp_p = fp_par(text.align = "center",line_spacing = 1,)))
  doc <- body_add_gg(doc,plot4)
  
  # doc <- body_add_fpar(doc, fpar( ftext("La situation hebdomadaire du réseau First Bank à travers les agrégats repris comme suit : ", prop = text_style), fp_p = fp_par(text.align = "justify",line_spacing = 1.5,) ) )
  # doc <- body_add_fpar(doc, fpar( ftext("      ✓   Les ressources", prop = text_style), fp_p = par_style ) )
  # doc <- body_add_fpar(doc, fpar( ftext("      ✓   Les reemplois", prop = text_style), fp_p = par_style ) )
  # doc <- body_add_fpar(doc, fpar( ftext("      ✓   Le recouvrement", prop = text_style), fp_p = par_style ) )
  # doc <- body_add_fpar(doc, fpar( ftext("      ✓   La production", prop = text_style), fp_p = par_style ) )
  # doc <- body_add_par(doc, " ")
  # doc <- body_add_fpar(doc, fpar( ftext("  I.     LES RESSOURCES", prop = text_style),
  #                                 fp_p = fp_par(text.align = "justify",line_spacing = 1.5,) ))
  # doc <- body_add_fpar(doc, fpar( ftext("    A- Situaton Globale", prop = text_style), fp_p = par_style ) )
  # doc <- body_add_fpar(doc, fpar( ftext(text1, prop = text_style), fp_p = par_style ))
  # doc <- body_add_par(doc, " ")
  # doc <- body_add_flextable(doc,set_table_properties(tab1, width = 1, layout = "autofit"))
  # doc <- body_add_par(doc," ")
  # doc <- body_add_fpar(doc, fpar( ftext("                                                                 Retail banking                            Corporate banking", prop = text_style), fp_p = par_style ) )
  # doc <- body_add_flextable(doc,set_table_properties(tab2, width = 1, layout = "autofit"))
  
  return(doc)
  
}
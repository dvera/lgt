#!/usr/bin/env r

  require(rvest)
  if (is.null(argv) | length(argv)<1) {
    langs <- NULL
  } else{
    langs <- argv
  }

  lgtdir=paste0(Sys.getenv("HOME"),"/.lgt/")
  archive=paste0(lgtdir,"archive")
  tmpfile=paste0(lgtdir,"tmp")
  lanfile=paste0(lgtdir,"languages")
  # tokfile=paste0(lgtdir,"token")

  if(!dir.exists(lgtdir)){
    dir.create(lgtdir)
  }

  if(!file.exists(lanfile)){
    write.table(data.frame(c("c","cpp","shell")),lanfile,row.names=F,col.names=F,quote=F)
  }

  if(is.null(langs)){
    langs <- read.table(lanfile,stringsAsFactors=F,quote=NULL)[,1]
  }

  # if(file.exists(tokfile)){
  #   hastoken=TRUE
  # } else{
  #   hastoken=FALSE
  # }

  for(l in langs){

    trending <- read_html(paste0("http://github.com/trending/",l))
    URLP=trending %>% html_nodes(".repo-list-name") %>% html_nodes("a") %>% html_attr("href")
    URLS=paste0("http://github.com",URLP)

    LANGS=trending %>% html_nodes(".repo-list-meta") %>% html_text(trim=T) %>% strsplit("\n") %>% lapply("[",1) %>% unlist
    nolang=grepl(" stars today",LANGS)
    if(any(nolang)){
      LANGS[which(nolang)]="none"
    }

    #NAMES=trending %>% html_nodes(".prefix") %>% html_text(trim=T)
    #NAMES=trending %>% html_nodes(".repo-list-name") %>% html_text(trim=T) %>% strsplit(split="\n") %>% lapply("[",1) %>% unlist
    NAMES=trending %>% html_nodes(".repo-list-name") %>% html_text(trim=T) %>% strsplit(split="\n") %>% lapply("[",3) %>% unlist %>% gsub(" ","",.)

    items=trending %>% html_nodes(".repo-list-item")

    DESC=(lapply(lapply(items,html_nodes,css=".repo-list-description"),html_text,trim=T))

    empty=!as.logical(unlist(lapply(DESC,length)))

    if(any(empty)){
      for(i in which(empty)){
        DESC[[i]]=""
      }
    }

    DESC=unlist(DESC)

    n=data.frame(V1=NAMES,V2=LANGS,V3=URLS,V4=DESC,stringsAsFactors=FALSE)

    if(file.exists(archive)){
      o=read.table(archive,header=F,stringsAsFactors=F,sep="\t",comment.char="",quote=NULL)
      r=which(n[,3] %in% o[,3])
      if(length(r)>0){ n=n[-r,] }
      o=rbind(o,n)
    } else{
      o=n
    }

    write.table(n,tmpfile,row.names=F,col.names=F,quote=F,sep="\t")
    write.table(o,archive,row.names=F,col.names=F,quote=F,sep="\t")

    system(paste("cat",tmpfile,"| awk -F'\t' '{print $1 \" (\"$2\") \"$3,$4,\"\"}' OFS='\t' | tr '\t' '\n'"))
  }

v <- read.csv("data_Valdieren_score_idents.csv", header=T)
cs <- c("Fiction", "History", "Poetry", "Drama", "Biology", "Music")
acum <- c()
for(c in cs) {
	c
	nc <- sum(v[,2] == c)
	rp <- sum(v[,2] == c & v[,3] == c)/nc
	rf <- sum(v[,2] == c & v[,4] == c)/nc
	svm <- sum(v[,2] == c & v[,5] == c)/nc
	cum <- cbind(c, nc, rp, rf, svm)
	acum <- rbind(acum, cum)
}
print(acum)
write.table(acum, file="acum.csv", quote=F)

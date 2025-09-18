*import buggy_crash_data_final excel file
encode State, gen(state)


replace Time = "10/2021" in 1
replace Time = "11/2021" in 2
replace Time = "12/2021" in 3
replace Time = "01/2022" in 4
replace Time = "02/2022" in 5
replace Time = "03/2022" in 6
replace Time = "04/2022" in 7
replace Time = "05/2022" in 8
replace Time = "06/2022" in 9
replace Time = "07/2022" in 10
replace Time = "08/2022" in 11
replace Time = "09/2022" in 12
replace Time = "10/2022" in 13
replace Time = "11/2022" in 14
replace Time = "12/2022" in 15
replace Time = "01/2023" in 16
replace Time = "02/2023" in 17
replace Time = "03/2023" in 18
replace Time = "04/2023" in 19
replace Time = "05/2023" in 20
replace Time = "06/2023" in 21
replace Time = "07/2023" in 22
replace Time = "08/2023" in 23
replace Time = "09/2023" in 24
replace Time = "10/2021" in 25
replace Time = "11/2021" in 26
replace Time = "12/2021" in 27
replace Time = "01/2022" in 28
replace Time = "02/2022" in 29
replace Time = "03/2022" in 30
replace Time = "04/2022" in 31
replace Time = "05/2022" in 32
replace Time = "06/2022" in 33
replace Time = "07/2022" in 34
replace Time = "08/2022" in 35
replace Time = "09/2022" in 36
replace Time = "10/2022" in 37
replace Time = "11/2022" in 38
replace Time = "12/2022" in 39
replace Time = "01/2023" in 40
replace Time = "02/2023" in 41
replace Time = "03/2023" in 42
replace Time = "04/2023" in 43
replace Time = "05/2023" in 44
replace Time = "06/2023" in 45
replace Time = "07/2023" in 46
replace Time = "08/2023" in 47
replace Time = "09/2023" in 48
replace Time = "10/2021" in 49
replace Time = "11/2021" in 50
replace Time = "12/2021" in 51
replace Time = "01/2022" in 52
replace Time = "02/2022" in 53
replace Time = "03/2022" in 54
replace Time = "04/2022" in 55
replace Time = "05/2022" in 56
replace Time = "06/2022" in 57
replace Time = "07/2022" in 58
replace Time = "08/2022" in 59
replace Time = "09/2022" in 60
replace Time = "10/2022" in 61
replace Time = "11/2022" in 62
replace Time = "12/2022" in 63
replace Time = "01/2023" in 64
replace Time = "02/2023" in 65
replace Time = "03/2023" in 66
replace Time = "04/2023" in 67
replace Time = "05/2023" in 68
replace Time = "06/2023" in 69
replace Time = "07/2023" in 70
replace Time = "08/2023" in 71
replace Time = "09/2023" in 72

gen time = monthly(Time, "MY")
gen treat=1 if state==3
replace treat=0 if state!=3
gen post=1 if time>=753
replace post=0 if time<753
gen treat_post=treat*post
rename Crashes crashes


gen ohio_crash=crashes if state==3
gen michigan_crash=crashes if state==2
gen kentucky_crash=crashes if state==1
sort time
by time: egen miky_crash= mean(crashes) if state==1 | state==2

sort time crashes

*additional help to get curly quotes in x-axis years
local rsq = ustrunescape("\u2019") // right single curly quote

twoway ///
    (connected ohio_crash time, lcolor(black) mcolor(black)) ///
    (connected miky_crash time, lcolor(gs8) mcolor(gs8)) ///
, xlabel(741 "Oct 21" 746 "Mar 22" 751 "Aug 22" 756 "Jan 23" 760 "May 23" 764 "Sep 23") ///
xtitle("Month") ///
ytitle("Total Buggy-Related Crashes") ///
legend(position(6) label(1 "Ohio") label(2 "Michigan/Kentucky")) ///
xline(753, lpattern(dash) lcolor(black))

graph export figure1.eps, as(eps) replace

local rsq = ustrunescape("\u2019") // right single curly quote

twoway ///
    (lfit miky_crash time if time<=752, lcolor(gs8) mcolor(gs8) legend(label(1 ""))) ///
    (lfit miky_crash time if time>752, lcolor(gs8) mcolor(gs8) legend(label(2 "Michigan/Kentucky"))) ///
    (scatter miky_crash time, lcolor(gs8) mcolor(gs8) legend(label(3 ""))) ///
    (lfit ohio_crash time if time<=752, lcolor(black) mcolor(black) legend(label(4 ""))) ///
    (lfit ohio_crash time if time>752, lcolor(black) mcolor(black) legend(label(5 "Ohio"))) ///
    (scatter ohio_crash time, lcolor(black) mcolor(black) legend(label(6 ""))) ///
, xlabel(741 "Oct 21" 746 "Mar 22" 751 "Aug 22" 756 "Jan 23" 760 "May 23" 764 "Sep 23") ///
    xtitle("Month") ///
    ytitle("Total Buggy-Related Crashes") ///
    legend(position(6) order(5 2) col(2)) ///
    xline(753, lpattern(dash) lcolor(black))

graph export figure2.eps, as(eps) replace


************
eststo crash1: reg crashes treat_post treat post


esttab crash1 using did_crash.tex, mtitle("Total Crashes") drop(_cons) label title(Avg Monthly Crashes) stats(N, label("Total Observations")) replace

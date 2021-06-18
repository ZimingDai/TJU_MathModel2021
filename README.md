# handcraft







通过自己搜集美国某地区历史数据，建模并分析该地区的 COVID-19 病毒传播情况。

### 符号

| 序号 | 符号      | 含义                                      | 初始值                                                       |
| ---- | --------- | ----------------------------------------- | ------------------------------------------------------------ |
| 1    | $S$       | 易感人群                                  | 21480000                                                     |
| 2    | $E$       | 潜伏期者                                  | 0                                                            |
| 3    | $I$       | 显性感染者                                | 5                                                            |
| 4    | $A$       | 隐性感染者                                | 0                                                            |
| 5    | $R$       | 康复者                                    | 0                                                            |
| 6    | $Q$       | 隔离人群                                  | 0                                                            |
| 7    | $p$       | 显性感染者比例系数                        | [瑞士研究](https://www.swissinfo.ch/chi/%E7%91%9E%E5%A3%AB%E7%A0%94%E7%A9%B6%E5%8F%91%E7%8E%B0-%E6%97%A0%E7%97%87%E7%8A%B6%E6%84%9F%E6%9F%93%E8%80%85%E4%BB%85%E5%8D%A0%E6%96%B0%E5%86%A0%E7%97%85%E6%AF%92%E6%84%9F%E6%9F%93%E4%BA%BA%E7%BE%A4%E7%BA%A6%E4%B8%A4%E6%88%90/46052932)约为0.8 |
| 8    | $\phi$    | 隔离比例                                  |                                                              |
| 9    | $\gamma$  | 康复系数$\frac{1}{illperiod}$             | $\frac{1}{15}=0.0667$                                        |
| 10   | $\omega$  | 潜伏人群变为感染者系数 $\frac{1}{expose}$ | $\frac{1}{14day}$                                            |
| 11   | $N$       | 区域全部人数                              | 21480000                                                     |
| 12   | $\beta_I$ | 传染率系数                                | [最新研究表明](https://www.yicai.com/news/100569749.html)6.3% |
| 13   | $m$       | 隐形潜伏者传染率为显性的比例              | 0.652                                                        |
| 14   | $r$       | 每天接触的人数                            |                                                              |
| 15   | $\alpha$  | 接种疫苗比例                              | 目前是43.8%                                                  |
| 16   | $k$       | 接种疫苗后得病率                          | 0.1                                                          |
| 17   | $b$       | 康复者复发+概率                           | 0                                                            |
| 18   | $\beta_e$ | 潜伏者传染率                              |                                                              |
| 19   | $t$       | 单位时间步长                              | 1 day                                                        |

### SEIARQ模型


$$
\frac{dS}{dt}= -\frac{S}{N}r[k\alpha+(1-\alpha)]\beta_I[(1-\phi)I+mA]-\frac{S}{N}r[k\alpha+(1-\alpha)]\beta_eE
$$

----

$$
\frac{dE}{dt} =\frac{S}{N}r[k\alpha+(1-\alpha)]\beta_I[(1-\phi)I+mA]+\frac{S}{N}r[k\alpha+(1-\alpha)]\beta_eE - \omega E
$$

---

$$
\frac{dI}{dt} = (1-p)\omega E - (1-\phi)\gamma I - \phi I
$$

---

$$
\frac{dA}{dt}= p\omega E - \gamma A
$$

---

$$
\frac{dR}{dt} = (1-\phi)\gamma I + \gamma(A+Q)
$$

---

$$
\frac{dQ}{dt}=\phi I - \gamma Q
$$

1. 式子一分为两个部分，第一个部分为感染者对于康复者的作用，第二个部分为潜伏者对于康复者的作用。
   * 第一部分
     * 首先$\frac{Sr}{N}$为每一个感染者每一个时间步长能接触到的易感人群的人数
     * $[ka+(1-a)]$为打疫苗之后等价的易感人群比例。
     * $[(1-\phi)I+mA]$为可以进行传染的感染者
   * 第二部分
     * 潜伏者对康复者的感染

2. 式子二分为三个部分，第一部分为S->E，第二部分为R->E，第三部分为E->I(A)
   * 第一部分：式子一的倒数，因为所有的S都会通过传染变成E。
   * 第二部分：有b的几率R会变成E
   * 第三部分：$\omega$为潜伏期倒数，即每个时间周期可能会有$\omega$比例的E变为I(A)
3. 式子三分为三个部分
   * 第一部分：所有潜伏者->感染者中有(1-p)的比例变成$I$
   * 第二部分：没有被隔离的人数是$(1-\phi)I$，其中有$\gamma$的人变成R
   * 第三部分：有$\phi I$的人直接被隔离到Q
4. 式子四分为两个部分
   * 第一部分：从E变为A的量
   * 第二部分：所有A通过$\gamma$变为R
5. 式子五分为三个部分：
   * 第一部分：I->R的量
   * 第二部分：被隔离的人和隐形感染者全部变成R
   * 第三部分：有b的比例变成E
6. 式子六分为两个部分
   * 有$\phi$的显性感染者隔离到Q
   * 隔离者变成R。



### SEIAR模型：

**整理后：**

我将$\frac{S}{N} \times r \times \beta$等价为$\lambda$ <kbd>为了方便运算</kbd>

| 序号 | 符号        | 含义                       | 初始值 |
| ---- | ----------- | -------------------------- | ------ |
| 1    | $\lambda_I$ | 每个显性感染者能感染多少人 |        |
| 2    | $\lambda_e$ | 每个潜伏患者能感染多少人   |        |


$$
\Delta S = -\lambda_I[I + 0.652A]- \lambda_eE
$$

$$
\Delta E =\lambda_I[I + 0.652A]+ \lambda_eE - \frac{1}{14}E
$$

$$
\Delta I = 0.2\times\frac{1}{14}E -\frac{1}{15}I
$$

$$
\Delta A = 0.8\times \frac{1}{14}\times E - \frac{1}{15}A
$$

$$
\Delta R = \frac{1}{15}(A+I)
$$


---
更改：要加入S
$$
\Delta S = -\lambda_I[I + 0.652A]S- \lambda_eES
$$

$$
\Delta E =\lambda_I[I + 0.652A]S+ \lambda_eES - \frac{1}{14}E
$$

$$
\Delta I = 0.2\times\frac{1}{14}E -\gamma I
$$

$$
\Delta A = 0.8\times \frac{1}{14}\times E - \gamma A
$$

$$
\Delta R = \gamma (A+I)
$$

#### 在拟合的时候要换成矩阵运算，所以SEIAR的矩阵如下：

$parameter=[\lambda_I, \lambda_e, \gamma, 1]$

$answer = [\Delta S, \Delta E, \Delta I, \Delta A, \Delta R]$

$matrix =  \left[ \begin{matrix}   -(I+0.652A) & -E & 0 & 0 \\   (I+0.652A) & E & 0 & -\frac{1}{14}E \\   0 & 0 & -I & 0.2\times\frac{1}{14}E \\ 0 & 0 & -A & 0.8 \times \frac{1}{14}E \\ 0 & 0 & (A+I) & 0  \end{matrix}  \right]$



;;; latex-prettify-symbols.el --- LaTeX prettify symbols list -*- lexical-binding: t; -*-

(defconst my-latex-prettify-symbols-alist
  '(
    ;; === amssymb conceals ===
    ("\\Bbbk" . ?𝕜) ("\\Bumpeq" . ?≎) ("\\Finv" . ?Ⅎ) ("\\Game" . ?⅁)
    ("\\Lleftarrow" . ?⇚) ("\\Rrightarrow" . ?⇛) ("\\Subset" . ?⋐) ("\\Supset" . ?⋑)
    ("\\Vdash" . ?⊩) ("\\Vvdash" . ?⊪) ("\\approxeq" . ?≊) ("\\backepsilon" . ?∍)
    ("\\backprime" . ?‵) ("\\backsim" . ?∽) ("\\backsimeq" . ?⋍) ("\\barwedge" . ?⊼)
    ("\\because" . ?∵) ("\\beth" . ?ℶ) ("\\between" . ?≬) ("\\bigstar" . ?★)
    ("\\blacklozenge" . ?◆) ("\\blacksquare" . ?■) ("\\blacktriangle" . ?▲) ("\\blacktriangledown" . ?▼)
    ("\\blacktriangleleft" . ?◀) ("\\blacktriangleright" . ?▶) ("\\boxdot" . ?⊡) ("\\boxminus" . ?⊟)
    ("\\boxplus" . ?⊞) ("\\boxtimes" . ?⊠) ("\\bumpeq" . ?≏) ("\\centerdot" . ?⋅)
    ("\\checkmark" . ?✓) ("\\circeq" . ?≗) ("\\circlearrowleft" . ?↺) ("\\circlearrowright" . ?↻)
    ("\\circledS" . ?Ⓢ) ("\\circledast" . ?⊛) ("\\circledcirc" . ?⊚) ("\\circleddash" . ?⊝)
    ("\\complement" . ?∁) ("\\curlyeqprec" . ?⋞) ("\\curlyeqsucc" . ?⋟) ("\\curlyvee" . ?⋎)
    ("\\curlywedge" . ?⋏) ("\\curvearrowleft" . ?↶) ("\\curvearrowright" . ?↷) ("\\daleth" . ?ℸ)
    ("\\diagdown" . ?╲) ("\\diagup" . ?╱) ("\\digamma" . ?ϝ) ("\\divideontimes" . ?⋇)
    ("\\doteqdot" . ?≑) ("\\dotplus" . ?∔) ("\\doublebarwedge" . ?⩞) ("\\downdownarrows" . ?⇊)
    ("\\downharpoonleft" . ?⇃) ("\\downharpoonright" . ?⇂) ("\\eqcirc" . ?≖) ("\\eqsim" . ?≂)
    ("\\eqslantgtr" . ?⪖) ("\\eqslantless" . ?⪕) ("\\fallingdotseq" . ?≒) ("\\geqq" . ?≧)
    ("\\geqslant" . ?⩾) ("\\gimel" . ?ℷ) ("\\gnapprox" . ?⪊) ("\\gneq" . ?⪈)
    ("\\gneqq" . ?≩) ("\\gnsim" . ?⋧) ("\\gtrapprox" . ?⪆) ("\\gtrdot" . ?⋗)
    ("\\gtreqless" . ?⋛) ("\\gtreqqless" . ?⪌) ("\\gtrless" . ?≷) ("\\gtrsim" . ?≳)
    ("\\gvertneqq" . ?) ("\\hslash" . ?ℏ) ("\\intercal" . ?⊺) ("\\leftarrowtail" . ?↢)
    ("\\leftleftarrows" . ?⇇) ("\\leftrightarrows" . ?⇆) ("\\leftrightharpoons" . ?⇋) ("\\leftrightsquigarrow" . ?↭)
    ("\\leftthreetimes" . ?⋋) ("\\leqq" . ?≦) ("\\leqslant" . ?⩽) ("\\lessapprox" . ?⪅)
    ("\\lessdot" . ?⋖) ("\\lesseqgtr" . ?⋚) ("\\lesseqqgtr" . ?⪋) ("\\lessgtr" . ?≶)
    ("\\lesssim" . ?≲) ("\\lnapprox" . ?⪉) ("\\lneq" . ?⪇) ("\\lneqq" . ?≨)
    ("\\lnsim" . ?⋦) ("\\looparrowleft" . ?↫) ("\\looparrowright" . ?↬) ("\\lozenge" . ?◊)
    ("\\ltimes" . ?⋉) ("\\lvertneqq" . ?) ("\\maltese" . ?✠) ("\\measuredangle" . ?∡)
    ("\\multimap" . ?⊸) ("\\nLeftarrow" . ?⇍) ("\\nLeftrightarrow" . ?⇎) ("\\nRightarrow" . ?⇏)
    ("\\nVDash" . ?⊯) ("\\nVdash" . ?⊮) ("\\ncong" . ?≆) ("\\nexists" . ?∄)
    ("\\ngeq" . ?≱) ("\\ngeqq" . ?) ("\\ngeqslant" . ?) ("\\ngtr" . ?≯)
    ("\\nleftarrow" . ?↚) ("\\nleftrightarrow" . ?↮) ("\\nleq" . ?≰) ("\\nleqq" . ?)
    ("\\nleqslant" . ?) ("\\nless" . ?≮) ("\\nmid" . ?∤) ("\\nparallel" . ?∦)
    ("\\nprec" . ?⊀) ("\\npreceq" . ?⋠) ("\\nrightarrow" . ?↛) ("\\nshortmid" . ?)
    ("\\nshortparallel" . ?) ("\\nsim" . ?≁) ("\\nsubseteq" . ?⊈) ("\\nsucc" . ?⊁)
    ("\\nsucceq" . ?⋡) ("\\nsupseteq" . ?⊉) ("\\ntriangleleft" . ?⋪) ("\\ntrianglelefteq" . ?⋬)
    ("\\ntriangleright" . ?⋫) ("\\ntrianglerighteq" . ?⋭) ("\\nvDash" . ?⊭) ("\\nvdash" . ?⊬)
    ("\\pitchfork" . ?⋔) ("\\precapprox" . ?⪷) ("\\preccurlyeq" . ?≼) ("\\precnapprox" . ?⪹)
    ("\\precneqq" . ?⪵) ("\\precnsim" . ?⋨) ("\\precsim" . ?≾) ("\\rightarrowtail" . ?↣)
    ("\\rightleftarrows" . ?⇄) ("\\rightrightarrows" . ?⇉) ("\\rightsquigarrow" . ?⇝) ("\\rightthreetimes" . ?⋌)
    ("\\risingdotseq" . ?≓) ("\\rtimes" . ?⋊) ("\\shortmid" . ?∣) ("\\shortparallel" . ?∥)
    ("\\smallfrown" . ?⌢) ("\\smallsetminus" . ?∖) ("\\smallsmile" . ?⌣) ("\\sphericalangle" . ?∢)
    ("\\square" . ?□) ("\\subseteqq" . ?⫅) ("\\subsetneq" . ?⊊) ("\\subsetneqq" . ?⫋)
    ("\\succapprox" . ?⪸) ("\\succcurlyeq" . ?≽) ("\\succnapprox" . ?⪺) ("\\succneqq" . ?⪶)
    ("\\succnsim" . ?⋩) ("\\succsim" . ?≿) ("\\supseteqq" . ?⫆) ("\\supsetneq" . ?⊋)
    ("\\supsetneqq" . ?⫌) ("\\therefore" . ?∴) ("\\thickapprox" . ?≈) ("\\thicksim" . ?∼)
    ("\\triangledown" . ?▽) ("\\trianglelefteq" . ?⊴) ("\\triangleq" . ?≜) ("\\trianglerighteq" . ?⊵)
    ("\\twoheadleftarrow" . ?↞) ("\\twoheadrightarrow" . ?↠) ("\\upharpoonleft" . ?↿) ("\\upharpoonright" . ?↾)
    ("\\upuparrows" . ?⇈) ("\\vDash" . ?⊨) ("\\varkappa" . ?ϰ) ("\\varnothing" . ?∅)
    ("\\varpropto" . ?∝) ("\\varsubsetneq" . ?) ("\\varsubsetneqq" . ?) ("\\varsupsetneq" . ?)
    ("\\varsupsetneqq" . ?) ("\\vartriangle" . ?△) ("\\vartriangleleft" . ?⊲) ("\\vartriangleright" . ?⊳)
    ("\\veebar" . ?⊻)

    ;; === standard math conceals ===
    ("\\aleph" . ?ℵ) ("\\amalg" . ?∐) ("\\angle" . ?∠) ("\\approx" . ?≈)
    ("\\ast" . ?∗) ("\\asymp" . ?≍) ("\\backslash" . ?∖) ("\\bigcap" . ?∩)
    ("\\bigcirc" . ?○) ("\\bigcup" . ?∪) ("\\bigodot" . ?⊙) ("\\bigoplus" . ?⊕)
    ("\\bigotimes" . ?⊗) ("\\bigsqcup" . ?⊔) ("\\bigtriangledown" . ?∇) ("\\bigtriangleup" . ?∆)
    ("\\bigvee" . ?⋁) ("\\bigwedge" . ?⋀) ("\\bot" . ?⊥) ("\\bowtie" . ?⋈)
    ("\\bullet" . ?•) ("\\cap" . ?∩) ("\\cdot" . ?·) ("\\cdots" . ?⋯)
    ("\\circ" . ?∘) ("\\clubsuit" . ?♣) ("\\cong" . ?≅) ("\\coprod" . ?∐)
    ("\\copyright" . ?©) ("\\cup" . ?∪) ("\\dagger" . ?†) ("\\dashv" . ?⊣)
    ("\\ddagger" . ?‡) ("\\ddots" . ?⋱) ("\\diamond" . ?⋄) ("\\diamondsuit" . ?♢)
    ("\\doteq" . ?≐) ("\\dots" . ?…) ("\\downarrow" . ?↓) ("\\Downarrow" . ?⇓)
    ("\\ell" . ?ℓ) ("\\emptyset" . ?Ø) ("\\equiv" . ?≡) ("\\exists" . ?∃)
    ("\\flat" . ?♭) ("\\forall" . ?∀) ("\\frown" . ?⌢) ("\\ge" . ?≥)
    ("\\geq" . ?≥) ("\\gt" . ?>) ("\\gets" . ?←) ("\\gg" . ?≫)
    ("\\hbar" . ?ℏ) ("\\heartsuit" . ?♡) ("\\hookleftarrow" . ?↩) ("\\hookrightarrow" . ?↪)
    ("\\iff" . ?⇔) ("\\Im" . ?ℑ) ("\\imath" . ?ɩ) ("\\in" . ?∈)
    ("\\infty" . ?∞) ("\\int" . ?∫) ("\\iint" . ?∬) ("\\iiint" . ?∭)
    ("\\fint" . ?⨍) ("\\jmath" . ?𝚥) ("\\land" . ?∧) ("\\lnot" . ?¬)
    ("\\lceil" . ?⌈) ("\\ldots" . ?…) ("\\le" . ?≤) ("\\leftarrow" . ?←)
    ("\\Leftarrow" . ?⇐) ("\\leftharpoondown" . ?↽) ("\\leftharpoonup" . ?↼) ("\\leftrightarrow" . ?↔)
    ("\\longleftrightarrow" . ?⟷) ("\\Leftrightarrow" . ?⇔) ("\\lhd" . ?◁) ("\\rhd" . ?▷)
    ("\\leq" . ?≤) ("\\lt" . ?<) ("\\ll" . ?≪) ("\\lmoustache" . ?╭)
    ("\\lor" . ?∨) ("\\mapsto" . ?↦) ("\\longmapsto" . ?⟼) ("\\mid" . ?∣)
    ("\\models" . ?⊨) ("\\mp" . ?∓) ("\\nabla" . ?∇) ("\\natural" . ?♮)
    ("\\ne" . ?≠) ("\\nearrow" . ?↗) ("\\neg" . ?¬) ("\\neq" . ?≠)
    ("\\ni" . ?∋) ("\\notin" . ?∉) ("\\nwarrow" . ?↖) ("\\odot" . ?⊙)
    ("\\oint" . ?∮) ("\\oiint" . ?∯) ("\\oiiint" . ?∰) ("\\ominus" . ?⊖)
    ("\\oplus" . ?⊕) ("\\oslash" . ?⊘) ("\\otimes" . ?⊗) ("\\owns" . ?∋)
    ("\\P" . ?¶) ("\\parallel" . ?║) ("\\partial" . ?∂) ("\\perp" . ?⊥)
    ("\\pm" . ?±) ("\\prec" . ?≺) ("\\preceq" . ?⪯) ("\\prime" . ?′)
    ("\\prod" . ?∏) ("\\propto" . ?∝) ("\\rceil" . ?⌉) ("\\Re" . ?ℜ)
    ("\\rightarrow" . ?→) ("\\xrightarrow" . ?→) ("\\longrightarrow" . ?⟶) ("\\Rightarrow" . ?⇒)
    ("\\rightleftharpoons" . ?⇌)
    ("\\rmoustache" . ?╮) ("\\S" . ?§) ("\\searrow" . ?↘) ("\\setminus" . ?⧵)
    ("\\sharp" . ?♯) ("\\sim" . ?∼) ("\\simeq" . ?⋍) ("\\smile" . ?⌣)
    ("\\spadesuit" . ?♠) ("\\sqcap" . ?⊓) ("\\sqcup" . ?⊔) ("\\sqsubset" . ?⊏)
    ("\\sqsubseteq" . ?⊑) ("\\sqsupset" . ?⊐) ("\\sqsupseteq" . ?⊒) ("\\star" . ?✫)
    ("\\subset" . ?⊂) ("\\subseteq" . ?⊆) ("\\succ" . ?≻) ("\\succeq" . ?⪰)
    ("\\sum" . ?∑) ("\\supset" . ?⊃) ("\\supseteq" . ?⊇) ("\\surd" . ?√)
    ("\\swarrow" . ?↙) ("\\times" . ?×) ("\\to" . ?→) ("\\top" . ?⊤)
    ("\\triangle" . ?∆) ("\\triangleleft" . ?⊲) ("\\triangleright" . ?⊳) ("\\uparrow" . ?↑)
    ("\\Uparrow" . ?⇑) ("\\updownarrow" . ?↕) ("\\Updownarrow" . ?⇕) ("\\vdash" . ?⊢)
    ("\\vdots" . ?⋮) ("\\vee" . ?∨) ("\\wedge" . ?∧) ("\\wp" . ?℘)
    ("\\wr" . ?≀) ("\\implies" . ?⇒) ("\\impliedby" . ?⇐) ("\\choose" . ?C)
    ("\\sqrt" . ?√) ("\\colon" . ?:) ("\\coloneqq" . ?≔) ("\\eqqcolon" . ?≕)
    ("\\xleftarrow" . ?←) ("\\longleftarrow" . ?⟵) ("\\xlongrightarrow" . ?⟶)

    ;; === delimiters & brackets ===
    ("\\lbrack" . ?\[) ("\\rbrack" . ?\])
    ("\\lparen" . ?\() ("\\rparen" . ?\))
    ("\\lbrace" . ?\{) ("\\rbrace" . ?\})
    ("\\{" . ?\{)      ("\\}" . ?\})
    ("\\|" . ?‖)
    ("\\langle" . ?⟨) ("\\rangle" . ?⟩)

    ;; === mathbb conceals ===
    ("\\mathbb{A}" . ?𝔸) ("\\mathbb{B}" . ?𝔹) ("\\mathbb{C}" . ?ℂ) ("\\mathbb{D}" . ?𝔻)
    ("\\mathbb{E}" . ?𝔼) ("\\mathbb{F}" . ?𝔽) ("\\mathbb{G}" . ?𝔾) ("\\mathbb{H}" . ?ℍ)
    ("\\mathbb{I}" . ?𝕀) ("\\mathbb{J}" . ?𝕁) ("\\mathbb{K}" . ?𝕂) ("\\mathbb{L}" . ?𝕃)
    ("\\mathbb{M}" . ?𝕄) ("\\mathbb{N}" . ?ℕ) ("\\mathbb{O}" . ?𝕆) ("\\mathbb{P}" . ?ℙ)
    ("\\mathbb{Q}" . ?ℚ) ("\\mathbb{R}" . ?ℝ) ("\\mathbb{S}" . ?𝕊) ("\\mathbb{T}" . ?𝕋)
    ("\\mathbb{U}" . ?𝕌) ("\\mathbb{V}" . ?𝕍) ("\\mathbb{W}" . ?𝕎) ("\\mathbb{X}" . ?𝕏)
    ("\\mathbb{Y}" . ?𝕐) ("\\mathbb{Z}" . ?ℤ)

    ;; === mathcal conceals ===
    ("\\mathcal{A}" . ?𝓐) ("\\mathcal{B}" . ?𝓑) ("\\mathcal{C}" . ?𝓒) ("\\mathcal{D}" . ?𝓓)
    ("\\mathcal{E}" . ?𝓔) ("\\mathcal{F}" . ?𝓕) ("\\mathcal{G}" . ?𝓖) ("\\mathcal{H}" . ?𝓗)
    ("\\mathcal{I}" . ?𝓘) ("\\mathcal{J}" . ?𝓙) ("\\mathcal{K}" . ?𝓚) ("\\mathcal{L}" . ?𝓛)
    ("\\mathcal{M}" . ?𝓜) ("\\mathcal{N}" . ?𝓝) ("\\mathcal{O}" . ?𝓞) ("\\mathcal{P}" . ?𝓟)
    ("\\mathcal{Q}" . ?𝓠) ("\\mathcal{R}" . ?𝓡) ("\\mathcal{S}" . ?𝓢) ("\\mathcal{T}" . ?𝓣)
    ("\\mathcal{U}" . ?𝓤) ("\\mathcal{V}" . ?𝓥) ("\\mathcal{W}" . ?𝓦) ("\\mathcal{X}" . ?𝓧)
    ("\\mathcal{Y}" . ?𝓨) ("\\mathcal{Z}" . ?𝓩)

    ;; === mathscr conceals ===
    ("\\mathscr{A}" . ?𝓐) ("\\mathscr{B}" . ?𝓑) ("\\mathscr{C}" . ?𝓒) ("\\mathscr{D}" . ?𝓓)
    ("\\mathscr{E}" . ?𝓔) ("\\mathscr{F}" . ?𝓕) ("\\mathscr{G}" . ?𝓖) ("\\mathscr{H}" . ?𝓗)
    ("\\mathscr{I}" . ?𝓘) ("\\mathscr{J}" . ?𝓙) ("\\mathscr{K}" . ?𝓚) ("\\mathscr{L}" . ?𝓛)
    ("\\mathscr{M}" . ?𝓜) ("\\mathscr{N}" . ?𝓝) ("\\mathscr{O}" . ?𝓞) ("\\mathscr{P}" . ?𝓟)
    ("\\mathscr{Q}" . ?𝓠) ("\\mathscr{R}" . ?𝓡) ("\\mathscr{S}" . ?𝓢) ("\\mathscr{T}" . ?𝓣)
    ("\\mathscr{U}" . ?𝓤) ("\\mathscr{V}" . ?𝓥) ("\\mathscr{W}" . ?𝓦) ("\\mathscr{X}" . ?𝓧)
    ("\\mathscr{Y}" . ?𝓨) ("\\mathscr{Z}" . ?𝓩)

    ;; === mathfrak lowercase ===
    ("\\mathfrak{a}" . ?𝔞) ("\\mathfrak{b}" . ?𝔟) ("\\mathfrak{c}" . ?𝔠) ("\\mathfrak{d}" . ?𝔡)
    ("\\mathfrak{e}" . ?𝔢) ("\\mathfrak{f}" . ?𝔣) ("\\mathfrak{g}" . ?𝔤) ("\\mathfrak{h}" . ?𝔥)
    ("\\mathfrak{i}" . ?𝔦) ("\\mathfrak{j}" . ?𝔧) ("\\mathfrak{k}" . ?𝔨) ("\\mathfrak{l}" . ?𝔩)
    ("\\mathfrak{m}" . ?𝔪) ("\\mathfrak{n}" . ?𝔫) ("\\mathfrak{o}" . ?𝔬) ("\\mathfrak{p}" . ?𝔭)
    ("\\mathfrak{q}" . ?𝔮) ("\\mathfrak{r}" . ?𝔯) ("\\mathfrak{s}" . ?𝔰) ("\\mathfrak{t}" . ?𝔱)
    ("\\mathfrak{u}" . ?𝔲) ("\\mathfrak{v}" . ?𝔳) ("\\mathfrak{w}" . ?𝔴) ("\\mathfrak{x}" . ?𝔵)
    ("\\mathfrak{y}" . ?𝔶) ("\\mathfrak{z}" . ?𝔷)

    ;; === mathfrak uppercase ===
    ("\\mathfrak{A}" . ?𝔄) ("\\mathfrak{B}" . ?𝔅) ("\\mathfrak{C}" . ?ℭ) ("\\mathfrak{D}" . ?𝔇)
    ("\\mathfrak{E}" . ?𝔈) ("\\mathfrak{F}" . ?𝔉) ("\\mathfrak{G}" . ?𝔊) ("\\mathfrak{H}" . ?ℌ)
    ("\\mathfrak{I}" . ?ℑ) ("\\mathfrak{J}" . ?𝔍) ("\\mathfrak{K}" . ?𝔎) ("\\mathfrak{L}" . ?𝔏)
    ("\\mathfrak{M}" . ?𝔐) ("\\mathfrak{N}" . ?𝔑) ("\\mathfrak{O}" . ?𝔒) ("\\mathfrak{P}" . ?𝔓)
    ("\\mathfrak{Q}" . ?𝔔) ("\\mathfrak{R}" . ?ℜ) ("\\mathfrak{S}" . ?𝔖) ("\\mathfrak{T}" . ?𝔗)
    ("\\mathfrak{U}" . ?𝔘) ("\\mathfrak{V}" . ?𝔙) ("\\mathfrak{W}" . ?𝔚) ("\\mathfrak{X}" . ?𝔛)
    ("\\mathfrak{Y}" . ?𝔜) ("\\mathfrak{Z}" . ?ℨ)

    ;; === greek conceals ===
    ("\\alpha" . ?α) ("\\beta" . ?β) ("\\gamma" . ?γ) ("\\delta" . ?δ)
    ("\\epsilon" . ?ϵ) ("\\varepsilon" . ?ε) ("\\zeta" . ?ζ) ("\\eta" . ?η)
    ("\\theta" . ?θ) ("\\vartheta" . ?ϑ) ("\\iota" . ?ι) ("\\kappa" . ?κ)
    ("\\lambda" . ?λ) ("\\mu" . ?μ) ("\\nu" . ?ξ) ("\\xi" . ?ξ)
    ("\\pi" . ?π) ("\\varpi" . ?ϖ) ("\\rho" . ?ρ) ("\\varrho" . ?ϱ)
    ("\\sigma" . ?σ) ("\\varsigma" . ?ς) ("\\tau" . ?τ) ("\\upsilon" . ?υ)
    ("\\phi" . ?ϕ) ("\\varphi" . ?φ) ("\\chi" . ?χ) ("\\psi" . ?ψ)
    ("\\omega" . ?ω) ("\\Gamma" . ?Γ) ("\\Delta" . ?Δ) ("\\Theta" . ?Θ)
    ("\\Lambda" . ?Λ) ("\\Xi" . ?Ξ) ("\\Pi" . ?Π) ("\\Sigma" . ?Σ)
    ("\\Upsilon" . ?Υ) ("\\Phi" . ?Φ) ("\\Chi" . ?Χ) ("\\Psi" . ?Ψ)
    ("\\Omega" . ?Ω)

    ;; === subscripts ===
    ("_0" . ?₀) ("_1" . ?₁) ("_2" . ?₂) ("_3" . ?₃) ("_4" . ?₄)
    ("_5" . ?₅) ("_6" . ?₆) ("_7" . ?₇) ("_8" . ?₈) ("_9" . ?₉)
    ("_a" . ?ₐ) ("_e" . ?ₑ) ("_h" . ?ₕ) ("_i" . ?ᵢ) ("_j" . ?ⱼ)
    ("_k" . ?ₖ) ("_l" . ?ₗ) ("_m" . ?ₘ) ("_n" . ?ₙ) ("_o" . ?ₒ)
    ("_p" . ?ₚ) ("_r" . ?ᵣ) ("_s" . ?ₛ) ("_t" . ?ₜ) ("_u" . ?ᵤ)
    ("_v" . ?ᵥ) ("_x" . ?ₓ)

    ("_{0}" . ?₀) ("_{1}" . ?₁) ("_{2}" . ?₂) ("_{3}" . ?₃) ("_{4}" . ?₄)
    ("_{5}" . ?₅) ("_{6}" . ?₆) ("_{7}" . ?₇) ("_{8}" . ?₈) ("_{9}" . ?₉)
    ("_{a}" . ?ₐ) ("_{e}" . ?ₑ) ("_{h}" . ?ₕ) ("_{i}" . ?ᵢ) ("_{j}" . ?ⱼ)
    ("_{k}" . ?ₖ) ("_{l}" . ?ₗ) ("_{m}" . ?ₘ) ("_{n}" . ?ₙ) ("_{o}" . ?ₒ)
    ("_{p}" . ?ₚ) ("_{r}" . ?ᵣ) ("_{s}" . ?ₛ) ("_{t}" . ?ₜ) ("_{u}" . ?ᵤ)
    ("_{v}" . ?ᵥ) ("_{x}" . ?ₓ)

    ("_{+}" . ?₊) ("_{-}" . ?₋)
    ("_+" . ?₊) ("_-" . ?₋)

    ;; === superscripts ===
    ("^0" . ?⁰) ("^1" . ?¹) ("^2" . ?²) ("^3" . ?³) ("^4" . ?⁴)
    ("^5" . ?⁵) ("^6" . ?⁶) ("^7" . ?⁷) ("^8" . ?⁸) ("^9" . ?⁹)
    ("^a" . ?ᵃ) ("^b" . ?ᵇ) ("^c" . ?ᶜ) ("^d" . ?ᵈ) ("^e" . ?ᵉ)
    ("^f" . ?ᶠ) ("^g" . ?ᵍ) ("^h" . ?ʰ) ("^i" . ?ⁱ) ("^j" . ?ʲ)
    ("^k" . ?ᵏ) ("^l" . ?ˡ) ("^m" . ?ᵐ) ("^n" . ?ⁿ) ("^o" . ?ᵒ)
    ("^p" . ?ᵖ) ("^r" . ?ʳ) ("^s" . ?ˢ) ("^t" . ?ᵗ) ("^u" . ?ᵘ)
    ("^v" . ?ᵛ) ("^w" . ?ʷ) ("^x" . ?ˣ) ("^y" . ?ʸ) ("^z" . ?ᶻ)
    ("^A" . ?ᴬ) ("^B" . ?ᴮ) ("^D" . ?ᴰ) ("^E" . ?ᴱ) ("^G" . ?ᴳ)
    ("^H" . ?ᴴ) ("^I" . ?ᴵ) ("^J" . ?ᴶ) ("^K" . ?ᴷ) ("^L" . ?ᴸ)
    ("^M" . ?ᴹ) ("^N" . ?ᴺ) ("^O" . ?ᴼ) ("^P" . ?ᴾ) ("^R" . ?ᴿ)
    ("^T" . ?ᵀ) ("^U" . ?ᵁ) ("^V" . ?ⱽ) ("^W" . ?ᵂ)

    ("^{0}" . ?⁰) ("^{1}" . ?¹) ("^{2}" . ?²) ("^{3}" . ?³) ("^{4}" . ?⁴)
    ("^{5}" . ?⁵) ("^{6}" . ?⁶) ("^{7}" . ?⁷) ("^{8}" . ?⁸) ("^{9}" . ?⁹)
    ("^{a}" . ?ᵃ) ("^{b}" . ?ᵇ) ("^{c}" . ?ᶜ) ("^{d}" . ?ᵈ) ("^{e}" . ?ᵉ)
    ("^{f}" . ?ᶠ) ("^{g}" . ?ᵍ) ("^{h}" . ?ʰ) ("^{i}" . ?ⁱ) ("^{j}" . ?ʲ)
    ("^{k}" . ?ᵏ) ("^{l}" . ?ˡ) ("^{m}" . ?ᵐ) ("^{n}" . ?ⁿ) ("^{o}" . ?ᵒ)
    ("^{p}" . ?ᵖ) ("^{r}" . ?ʳ) ("^{s}" . ?ˢ) ("^{t}" . ?ᵗ) ("^{u}" . ?ᵘ)
    ("^{v}" . ?ᵛ) ("^{w}" . ?ʷ) ("^{x}" . ?ˣ) ("^{y}" . ?ʸ) ("^{z}" . ?ᶻ)
    ("^{A}" . ?ᴬ) ("^{B}" . ?ᴮ) ("^{D}" . ?ᴰ) ("^{E}" . ?ᴱ) ("^{G}" . ?ᴳ)
    ("^{H}" . ?ᴴ) ("^{I}" . ?ᴵ) ("^{J}" . ?ᴶ) ("^{K}" . ?ᴷ) ("^{L}" . ?ᴸ)
    ("^{M}" . ?ᴹ) ("^{N}" . ?ᴺ) ("^{O}" . ?ᴼ) ("^{P}" . ?ᴾ) ("^{R}" . ?ᴿ)
    ("^{T}" . ?ᵀ) ("^{U}" . ?ᵁ) ("^{V}" . ?ⱽ) ("^{W}" . ?ᵂ)

    ("^{+}" . ?⁺) ("^{-}" . ?⁻)
    ("^+" . ?⁺) ("^-" . ?⁻)
    )
  "A list of LaTeX commands and their corresponding Unicode display representations.")

(defconst my-latex-operator-symbols-list
  '(
    ;; === Large Operators & Integrals ===
    "sum" "prod" "coprod" "bigcap" "bigcup" "bigsqcap" "bigsqcup" "bigotimes"
    "bigoplus" "bigwedge" "bigvee" "bigodot" "biguplus"
    "int" "iint" "iiint" "oint" "oiint" "oiiint" "idotsint"

    ;; === Trigonometric & Hyperbolic Functions ===
    "sin" "cos" "tan" "cot" "sec" "csc"
    "arcsin" "arccos" "arctan"
    "sinh" "cosh" "tanh" "coth" "sech" "csch"
    "arcsinh" "arccosh" "arctanh"

    ;; === Calculus, Limits & Analysis ===
    "lim" "liminf" "limsup" "varinjlim" "varprojlim" "injlim" "projlim"
    "inf" "sup" "max" "min" "maximize" "minimize" "argmax" "argmin"
    "log" "ln" "lg" "exp" "deg" "det" "dim" "ker" "coker"
    "grad" "curl" "div" "Hess" "diff" "partial" "nabla"

    ;; === Algebra, Logic & Set Theory Operators ===
    "arg" "gcd" "lcm" "ord" "sgn" "Pr" "Var" "Cov" "diam" "Vol" "rank" "tr" "Tr"
    "Spec" "Proj" "Res" "Hom" "hom" "Tor" "Ext" "End" "Aut" "Inn" "Out"
    "GL" "SL" "SU" "SO" "Sp" "diag" "span" "supp" "codim" "coim" "im" "dom" "ran" "char"
    "Gal" "Mor" "Ann" "Ass" "Obj" "card" "id" "identity"
    "II" "empty" "emptyset" "varnothing" "aleph" "ell"

    ;; === Arrows & Maps ===
    "to" "gets" "iff" "implies" "impliedby"
    "leftarrow" "rightarrow" "leftrightarrow" "longleftrightarrow" "longleftarrow" "longrightarrow"
    "Leftarrow" "Rightarrow" "Leftrightarrow" "Longerrightarrow" "Longleftarrow" "Longleftrightarrow"
    "rightrightarrows" "leftleftarrows" "twoheadrightarrow" "twoheadleftarrow"
    "hookrightarrow" "hookleftarrow" "mapsto" "longmapsto"
    "uparrow" "downarrow" "updownarrow" "Updownarrow"
    "searrow" "nearrow" "swarrow" "nwarrow" "xrightarrow" "xleftarrow"

    ;; === Binary Operators & Relations ===
    "pm" "mp" "times" "div" "cdot" "circ" "ast" "star" "bullet"
    "oplus" "otimes" "odot" "ominus" "uplus" "cap" "cup" "sqcap" "sqcup" "setminus"
    "flat" "sharp" "smile" "frown" "dagger" "parallel" "perp" "bot" "wp" "hbar"
    "prec" "succ" "neq" "leq" "geq" "leqslant" "geqslant" "cong" "equiv" "ll" "gg"
    "approx" "simeq" "sim" "propto" "asymp" "nmid" "mid" "vee" "wedge" "land" "lor"
    "in" "notin" "ni" "subset" "supset" "subseteq" "supseteq" "Subset" "Supset"
    "sqsubset" "sqsupset" "sqsubseteq" "sqsupseteq" "square" "blacksquare"

    ;; === Logic & Formatting / Spacing ===
    "forall" "exists" "neg" "quad" "qquad" "mod" "pmod"
    )
  "A list of LaTeX operators.")

(provide 'my-latex-prettify-symbols)
;;; latex-prettify-symbols.el ends here

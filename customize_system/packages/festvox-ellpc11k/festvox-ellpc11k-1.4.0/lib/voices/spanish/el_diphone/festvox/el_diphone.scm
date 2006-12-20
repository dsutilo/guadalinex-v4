;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                       ;;
;;;                Centre for Speech Technology Research                  ;;
;;;                     University of Edinburgh, UK                       ;;
;;;                       Copyright (c) 1996,1997                         ;;
;;;                        All Rights Reserved.                           ;;
;;;                                                                       ;;
;;;  Permission is hereby granted, free of charge, to use and distribute  ;;
;;;  this software and its documentation without restriction, including   ;;
;;;  without limitation the rights to use, copy, modify, merge, publish,  ;;
;;;  distribute, sublicense, and/or sell copies of this work, and to      ;;
;;;  permit persons to whom this work is furnished to do so, subject to   ;;
;;;  the following conditions:                                            ;;
;;;   1. The code must retain the above copyright notice, this list of    ;;
;;;      conditions and the following disclaimer.                         ;;
;;;   2. Any modifications must be clearly marked as such.                ;;
;;;   3. Original authors' names are not deleted.                         ;;
;;;   4. The authors' names are not used to endorse or promote products   ;;
;;;      derived from this software without specific prior written        ;;
;;;      permission.                                                      ;;
;;;                                                                       ;;
;;;  THE UNIVERSITY OF EDINBURGH AND THE CONTRIBUTORS TO THIS WORK        ;;
;;;  DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING      ;;
;;;  ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT   ;;
;;;  SHALL THE UNIVERSITY OF EDINBURGH NOR THE CONTRIBUTORS BE LIABLE     ;;
;;;  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    ;;
;;;  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN   ;;
;;;  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,          ;;
;;;  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF       ;;
;;;  THIS SOFTWARE.                                                       ;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  A Castilian Spanish male voice
;;;
;;;  Authors: Alistair Conkie (initially), Borja Etxebarria, Alan W Black
;;;           Eduardo Lopez (who did the diphones)
;;;
;;;  Eduardo Lopez, MSc student DAI 1992 made (and spoke) the diphones.
;;;
;;;  Note although the front end is free the diphones are restricted to
;;;  non-commercial use only.
;;;
;;;  This is by no means complete:
;;;  Intonation is pretty weak and without good phrase breaks
;;;    the continous downward slope with small accents is not good
;;;  Numbers are not dealt with properly when they are supposed to
;;;    inflect for gender.
;;;  There's no part of speech tagging which woudl allow number matching
;;;    phrasing etc.
;;;  The diphone database is missing accented vowels and diphthongs
;;;    making small but not as good as it could be.
;;;  It hasn't really been tested thoroughly
;;;

;;;  Add the directory contains general spanish stuff to load-path
(defvar spanish_el_dir (cdr (assoc 'el_diphone voice-locations)))
(set! load-path (cons (path-append spanish_el_dir "festvox/") load-path))

;;; other files we need
(require 'spanlex)
(require 'spanint)
(require 'sptoken)
(require_module 'UniSyn)

(defPhoneSet
  spanish
  ;;;  Phone Features
  (;; vowel or consonant
   (vc + -)  
   ;; vowel length: short long dipthong schwa
   (vlng s l d a 0)
   ;; vowel height: high mid low
   (vheight 1 2 3 -)
   ;; vowel frontness: front mid back
   (vfront 1 2 3 -)
   ;; lip rounding
   (vrnd + -)
   ;; consonant type: stop fricative affricative nasal liquid
   (ctype s f a n l 0)
   ;; place of articulation: labial alveolar palatal labio-dental
   ;;                         dental velar
   (cplace l a p b d v 0)
   ;; consonant voicing
   (cvox + -)
   )
  ;; borja: all the features are almost ok, only some problems:
  ;; r is a tap, rr is a trill.  We would need "vibrant". Now, coded as liquid.
  ;; l and ll are lateral. Now, coded as liquid (probably it's the samething)
  ;; The bdg/BDG distinction (stop/aproximant) is not done.
  ;; The i and u aproximants (sampa j and w, labio, agua) are not considered,
  ;; normal i and u used instead.
  ;; The ficative 'y' (sampa jj, ayer) is not considered, ll used instead.
  (
   (#  - 0 - - - 0 0 -)
   (a  + l 3 2 - 0 0 -)
   (e  + l 2 1 - 0 0 -)
   (i  + l 1 1 - 0 0 -)
   (o  + l 2 3 + 0 0 -)
   (u  + l 1 3 + 0 0 -)
   (i0  + s 1 1 - 0 0 -)  ;; weak vowels in dipthongs
   (u0  + s 1 3 + 0 0 -)  ;; weak vowels in dipthongs

   (a1 + l 3 2 - 0 0 -)
   (e1 + l 2 1 - 0 0 -)
   (i1 + l 1 1 - 0 0 -)
   (o1 + l 2 3 + 0 0 -)
   (u1 + l 1 3 + 0 0 -)

   (p  - 0 - - - s l -)
   (t  - 0 - - - s d -)
   (k  - 0 - - - s v -)
   (b  - 0 - - - s l +)
   (d  - 0 - - - s d +)
   (g  - 0 - - - s v +)

   (f  - 0 - - - f b -)
   (th - 0 - - - f d -)
   (s  - 0 - - - f a -)
   (x  - 0 - - - f v -)

   (ch - 0 - - - a p -)

   (m  - 0 - - - n l +)
   (n  - 0 - - - n a +)
   (ny - 0 - - - n p +)

   (l  - 0 - - - l a +)
   (ll - 0 - - - l p +)

   (r  - 0 - - - l a +)
   (rr - 0 - - - l a +)
  )
)
(PhoneSet.silences '(#))

;;; Part of speech down by crude lookup using gpos 
(set! spanish_guess_pos 
'((fn
    el la lo los las 
    un una unos unas
;;
    mi tu su mis tus sus 
    nuestra vuestra nuestras vuestras nuestro vuestro nuestros vuestros
    me te le nos os les se
    al del
;;
    a ante bajo cabe con contra de desde en entre
    hacia hasta para por sin sobre tras mediante
;;
    y e ni mas o "\'o" u pero aunque si 
    porque que quien cuando como donde cual cuan
    aun pues tan mientras sino )
  (partnums
   dieci venti trentai cuarentai cincuentai sesentai ochentai noventai)
  )
)

;;; Phrase breaks
;;;    use punctuation 
(set! spanish_phrase_cart_tree
'
((lisp_token_end_punc in ("'" "\"" "?" "." "," ":" ";"))
  ((B))
  ((n.name is 0)
   ((B))
   ((NB)))))

;;; Intonation
(set! spanish_accent_cart_tree
  '
  (
   (R:SylStructure.parent.gpos is content)
    ( (stress is 1)
       ((Accented))
       ((NONE))
    )
  )
)


;;; Duration 
(set! spanish_dur_tree
 '
   ((R:SylStructure.parent.R:Syllable.p.syl_break > 1 ) ;; clause initial
    ((R:SylStructure.parent.stress is 1)
     ((1.5))
     ((1.2)))
    ((R:SylStructure.parent.syl_break > 1)   ;; clause final
     ((R:SylStructure.parent.stress is 1)
      ((1.5))
      ((1.2)))
     ((R:SylStructure.parent.stress is 1)
      ((ph_vc is +)
       ((1.2))
       ((1.0)))
      ((1.0))))))

(set! spanish_el_phone_data
'(
   (# 0.0 0.250)
   (a 0.0 0.080)
   (e 0.0 0.080)
   (i 0.0 0.070)
   (o 0.0 0.080)
   (u 0.0 0.070)
   (i0 0.0 0.040)
   (u0 0.0 0.040)
   (a1 0.0 0.090)
   (e1 0.0 0.090)
   (i1 0.0 0.080)
   (o1 0.0 0.090)
   (u1 0.0 0.080)
   (b 0.0 0.065)
   (ch 0.0 0.135)
   (d 0.0 0.060)
   (f 0.0 0.100)
   (g 0.0 0.080)
   (j 0.0 0.100)
   (k 0.0 0.100)
   (l 0.0 0.080)
   (ll 0.0 0.105)
   (m 0.0 0.070)
   (n 0.0 0.080)
   (ny 0.0 0.110)
   (p 0.0 0.100)
   (r 0.0 0.030)
   (rr 0.0 0.080)
   (s 0.0 0.110)
   (t 0.0 0.085)
   (th 0.0 0.100)
   (x 0.0 0.130)
))

(set! el_lpc_sep 
      (list
       '(name "el_lpc_sep")
       (list 'index_file (path-append spanish_el_dir "dic/eldiph.est"))
       '(grouped "false")
       (list 'coef_dir (path-append spanish_el_dir "lpc"))
       (list 'sig_dir  (path-append spanish_el_dir "lpc"))
       '(coef_ext ".lpc")
       '(sig_ext ".res")
       '(default_diphone "#-#")))

(set! el_lpc_group 
      (list
       '(name "el_lpc_group")
       (list 'index_file 
	     (path-append spanish_el_dir "group/ellpc11k.group"))
       '(grouped "true")
       '(default_diphone "#-#")))

;; Go ahead and set up the diphone db
(us_diphone_init el_lpc_group)

(define (el_diphone_fix utt)
"(el_diphone_fix UTT)
Map accents vowels to unaccented ones because the db doesn't
have them."
  (mapcar
   (lambda (s)
     (let ((name (item.name s)))
       (cond
	((string-matches name ".1")
	 (item.set_feat s "us_diphone" (string-before name "1")))
	((string-matches name ".0")
	 (item.set_feat s "us_diphone" (string-before name "0"))))))
   (utt.relation.items utt 'Segment))
  utt)

(define (spanish_voice_reset)
  "(spanish_voice_reset)
Reset global variables back to previous voice."
  (set! token.prepunctuation spanish_previous_tok_prepunc)
)

;;;  Full voice definition 
(define (voice_el_diphone)
"(voice_spanish_el)
Set up synthesis for Male Spanish speaker: Eduardo Lopez"
  (voice_reset)
  (Parameter.set 'Language 'spanish)
  ;; Phone set
  (Parameter.set 'PhoneSet 'spanish)
  (PhoneSet.select 'spanish)

  ;; numeric expansion
  (Parameter.set 'Token_Method 'Token_Any)
  (set! token_to_words spanish_token_to_words)

  ;; Because of use of ' for accents remove it from prepunctuation
  (set! spanish_previous_tok_prepunc token.prepunctuation)
  (set! token.prepunctuation "\"`({[")

  ;; No pos prediction (get it from lexicon)
  (set! pos_lex_name nil)
  ;; Phrase break prediction by punctuation
  (set! pos_supported nil) ;; well not real pos anyhow
  ;; Phrasing
  (set! phrase_cart_tree spanish_phrase_cart_tree)
  (Parameter.set 'Phrase_Method 'cart_tree)
  ;; Lexicon selection
  (lex.select "spanish")

  ;; Accent and tone prediction
  (set! int_accent_cart_tree spanish_accent_cart_tree)

  (Parameter.set 'Int_Target_Method 'Simple)

  (Parameter.set 'Int_Method 'General)
  (set! int_general_params (list (list 'targ_func targ_func1)))
  (set! guess_pos spanish_guess_pos) 

  ;; Duration prediction
  (set! duration_cart_tree spanish_dur_tree)
  (set! duration_ph_info spanish_el_phone_data)
  (Parameter.set 'Duration_Method 'Tree_ZScores)

  ;; Waveform synthesizer: diphones
  (set! UniSyn_module_hooks (list el_diphone_fix))
  (set! us_abs_offset 0.0)
  (set! window_factor 1.0)
  (set! us_rel_offset 0.0)
  (set! us_gain 0.9)

  (Parameter.set 'Synth_Method 'UniSyn)
  (Parameter.set 'us_sigpr 'lpc)
  (us_db_select 'el_lpc_group)

  ;; set callback to restore some original values changed by the spanish voice
  (set! current_voice_reset spanish_voice_reset)

  (set! current-voice 'el_diphone)
)

(proclaim_voice
 'el_diphone
 '((language spanish)
   (gender male)
   (dialect castilian)
   (description
    "This voice provides a Castilian Spanish male voice using a
     residual excited LPC diphone synthesis method.  The lexicon
     is provived by a set of letter to sound rules producing pronunciation
     accents and syllabification.  The durations, intonation and
     prosodic phrasing are minimal but are acceptable for simple
     examples.")))

(provide 'el_diphone)

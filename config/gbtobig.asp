<%
function GbToBig(byval content)
 dim s,t,c,d,i
 s="��,��,��,ר,ҵ,��,��,˿,��,��,��,ɥ,��,��,��,��,Ϊ,��,��,ô,��,��,��,��,ϰ,��,��,��,��,��,��,��,��,ب,��,��,Ķ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ɡ,ΰ,��,��,��,��,��,α,��,��,��,Ӷ,��,��,��,��,��,��,��,��,٭,ٯ,ٶ,ٱ,ٲ,��,ٳ,��,ծ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,д,��,ũ,ڣ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ƾ,��,��,��,��,ۻ,��,��,��,��,��,ɾ,��,�i,��,��,��,��,��,��,��,��,��,Ȱ,��,��,۽,��,��,��,��,��,ѫ,��,��,��,��,��,��,ҽ,��,Э,��,��,¬,±,��,��,ȴ,��,��,��,��,��,ѹ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,˫,��,��,��,��,Ҷ,��,̾,ߴ,��,��,��,��,��,��,��,��,��,��,߼,߽,Ż,߿,��,Ա,��,Ǻ,��,ӽ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,Ӵ,��,�y,��,�|,��,��,��,��,��,��,��,��,��,��,Х,��,�,�,�,��,��,��,��,��,��,��,��,��,��,԰,��,Χ,��,��,ͼ,Բ,ʥ,��,��,��,��,��,��,̳,��,��,��,��,׹,¢,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ǵ,��,�G,ܫ,ǽ,׳,��,��,��,��,��,��,��,��,ͷ,��,��,��,��,ۼ,��,��,��,ױ,��,��,��,��,�,�,��,¦,�,�,��,�,��,�,�,�O,Ӥ,�,��,��,��,��,��,��,��,ѧ,��,��,��,ʵ,��,��,��,��,��,��,��,��,Ѱ,��,��,��,��,��,��,Ң,��,ʬ,��,��,��,��,��,��,��,��,��,��,��,�,��,�,�,�,��,��,��,�,��,�N,�,Ͽ,�i,�,�,��,��,��,��,ո,��,��,��,��,��,��,��,��,��,˧,ʦ,��,��,��,��,��,֡,��,��,��,��,��,�,��,��,��,��,ׯ,��,®,��,��,Ӧ,��,��,��,��,��,��,��,��,��,��,��,��,��,ǿ,��,��,¼,��,��,��,��,��,��,��,��,��,��,��,̬,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�,��,��,��,�,��,��,��,��,��,��,�,��,��,��,��,�,��,�,Ը,��,�\,��,��,��,��,��,�,Ϸ,�,ս,�,��,��,��,Ǥ,ִ,��,��,ɨ,��,��,��,��,��,��,��,��,��,��,��,��,£,��,ӵ,��,š,��,��,��,ֿ,��,��,��,̢,Ю,��,��,��,��,��,��,��,��,��,��,��,��,��,��,°,��,��,��,��,��,��,��,��,��,��,§,��,Я,��,��,��,ҡ,��,̯,��,��,��,ߢ,ߣ,ߥ,��,��,��,��,��,ի,�,��,ն,��,��,��,ʱ,��,�D,�,��,�o,��,��,ɹ,��,��,��,��,��,��,��,��,��,��,ɱ,��,Ȩ,��,��,��,�,��,��,��,��,��,��,��,��,��,ǹ,��,��,��,��,��,��,դ,��,ջ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,׮,��,��,��,��,��,�,��,��,�,��,¥,�,�,�,�,��,��,��,��,��,��,ӣ,��,��,��,��,��,��,��,�,ŷ,��,��,��,��,��,��,��,��,Ź,��,�,��,��,ձ,�,�,��,��,�,�,��,��,��,��,��,��,��,û,��,Ž,��,��,��,�h,��,��,�m,Ţ,��,��,��,��,��,к,��,��,��,��,��,��,�,ǳ,��,��,�,��,��,��,�,��,�,��,��,�,Ũ,�,��,Ϳ,ӿ,��,��,�,��,�,��,��,��,��,��,��,��,ɬ,��,Ԩ,��,��,��,��,��,��,��,��,��,��,��,ʪ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,̲,��,��,��,��,��,Ϋ,Ǳ,��,��,��,��,�,��,��,��,��,��,�,¯,��,�,��,��,��,��,˸,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ү,�,��,ǣ,��,��,��,��,״,��,��,��,��,��,�A,��,��,��,ʨ,��,��,��,��,��,��,�,�,��,è,�,��,̡,��,�_,�`,��,��,��,��,�o,��,��,��,��,��,��,��,�Q,��,��,��,��,�,�,�,�,��,�,��,��,��,�,��,��,��,ű,��,��,��,��,��,��,��,Ӹ,��,��,��,��,��,��,��,��,�},��,��,��,̱,�,�,�,Ѣ,�,�,��,��,��,յ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ש,��,��,��,��,��,��,��,�n,��,˶,��,��,�},�~,ȷ,��,��,��,��,��,��,��,��,�t,��,��,��,��,��,»,��,��,ͺ,��,��,��,��,��,��,��,˰,��,��,�,��,��,��,Ҥ,��,��,��,�,��,��,��,��,��,��,��,��,��,��,��,��,ɸ,�Y,��,��,ǩ,��,��,��,��,��,��,��,��,��,¨,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,Լ,��,��,��,��,��,γ,�,��,��,�,ɴ,��,��,��,��,��,��,ֽ,��,��,��,��,Ŧ,�,��,�,�,�,��,��,��,ϸ,֯,��,�,��,�,�,��,��,��,�,��,��,��,�,��,��,�,��,��,Ѥ,�,��,��,��,ͳ,�,�,��,��,��,��,��,��,�,��,��,�,��,��,�,�,��,�,�,��,ά,��,�,��,��,��,�,�,��,��,�,��,׺,�,�,�,��,��,��,�,�,��,��,��,��,�,��,��,��,��,��,��,��,��,��,��,Ե,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ӧ,��,��,��,��,��,��,��,��,��,��,��,��,��,�,��,��,��,��,�,�,��,��,��,��,��,��,��,��,��,��,��,ְ,��,��,��,��,��,��,��,��,��,��,��,в,��,ʤ,��,��,��,��,��,��,��,��,��,��,ŧ,��,��,��,��,��,��,��,�N,��,��,��,��,��,��,�H,��,��,��,��,��,��,��,ܳ,��,��,��,ܼ,��,«,��,έ,��,��,��,��,��,��,��,ƻ,��,��,��,��,��,��,��,��,�Q,��,��,��,��,��,��,��,��,��,��,��,ӫ,ݡ,ݣ,ݥ,��,ݤ,ݦ,ݧ,ҩ,ݰ,ݯ,��,��,ݪ,ݫ,ݲ,��,ݵ,Ө,ݺ,ݻ,�[,��,ө,Ӫ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,Ǿ,��,��,��,ޭ,��,޴,޻,޺,²,��,��,��,�,�,��,Ϻ,�,ʴ,��,��,��,�,�,��,��,��,��,��,��,��,��,��,��,��,��,Ӭ,��,��,Ы,��,��,΅,��,�],��,��,��,��,��,��,��,Є,��,Ϯ,�B,װ,��,�T,��,��,��,��,��,��,��,�[,��,��,�_,��,��,��,��,��,��,��,��,��,�`,��,��,��,��,��,��,��,Ԁ,��,��,ڥ,��,��,��,��,��,ڦ,ڧ,��,��,ڨ,��,ѵ,��,Ѷ,��,ך,��,��,ک,ڪ,��,ګ,��,��,��,כ,��,��,��,��,��,֤,ڬ,ڭ,��,��,ʶ,ל,թ,��,��,ڮ,��,��,ڰ,گ,ם,��,ڱ,ڲ,ڳ,��,ڴ,ʫ,ڵ,ڶ,ڶ,��,ڷ,��,��,ڸ,ڹ,��,ѯ,��,ں,��,��,��,ڻ,ڼ,מ,��,��,��,ڽ,��,ھ,��,��,ڿ,˵,��,��,��,��,��,ŵ,��,��,��,��,��,��,˭,��,��,��,��,׻,��,̸,��,ı,��,��,��,��,г,��,��,ν,��,��,��,��,��,��,��,��,��,��,נ,��,��,��,л,ҥ,��,��,ǫ,��,��,á,��,��,��,̷,��,��,��,��,��,��,Ǵ,��,��,��,�k,��,��,��,�O,��,��,��,��,��,��,��,��,��,̰,ƶ,��,��,��,��,��,��,��,��,��,��,��,��,ó,��,��,��,��,��,��,��,��,��,¸,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�P,�Q,��,��,��,��,�R,׸,��,׬,��,��,��,��,�S,��,��,Ӯ,��,�W,��,��,��,��,��,Ծ,��,��,��,��,�Q,��,��,��,��,ӻ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�a,��,ת,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�b,��,��,��,��,��,��,��,��,��,��,��,�c,�,�,�,��,��,�d,��,��,ԯ,Ͻ,շ,�,��,�,��,��,��,��,��,��,Ǩ,��,��,��,��,��,��,Զ,Υ,��,��,��,��,��,��,ѡ,ѷ,��,��,��,��,ң,��,��,��,��,��,��,��,��,ۧ,ۣ,ۦ,֣,۩,۪,��,��,��,�N,��,��,��,��,��,��,�,��,��,��,��,��,��,��,��,��,��,��,ǥ,��,��,�,��,��,��,��,�,��,�,��,��,��,��,��,��,��,��,��,��,��,Կ,��,��,��,��,��,��,��,��,ť,��,��,Ǯ,��,ǯ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,Ǧ,í,��,��,��,��,��,��,��,�,��,��,��,�,�,��,��,��,��,��,�,��,ͭ,��,��,��,��,ա,��,ϳ,��,��,�,��,��,�,��,�,��,��,�,�,��,ҿ,��,�,�,�,��,�,��,�,��,�,�,�,��,�,��,��,�,�,��,��,�,�,��,�,�,��,п,�,�,�,��,��,�,�,�,�,�,��,�,��,ê,�,�,�,�,�,�,��,��,��,��,׶,��,�@,��,��,��,��,��,��,��,��,��,��,��,�A,��,��,��,��,��,��,��,��,��,�B,��,��,��,þ,��,�C,��,��,��,��,�D,��,��,�E,��,��,��,��,��,��,��,��,��,�F,��,��,��,��,�G,��,��,��,��,��,�H,��,��,��,��,��,��,��,��,��,��,��,��,��,�I,��,��,��,��,��,�J,�K,��,��,��,��,��,��,�\,��,��,��,��,��,��,��,��,��,��,��,բ,��,��,��,��,��,��,�],��,��,��,��,��,��,��,�^,��,��,��,��,��,��,��,��,��,��,��,�_,��,��,��,��,�`,��,��,�a,��,��,��,��,��,��,½,¤,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ù,��,��,��,��,��,��,��,��,Τ,��,�,��,�,�,�,��,ҳ,��,��,��,��,˳,��,��,��,��,��,��,��,��,��,Ԥ,­,��,��,��,�,��,�F,�,�,�G,�,��,Ƶ,�H,��,�,�I,ӱ,��,��,�J,�,�,��,��,�,�,��,�,�,�K,��,�,�,ȧ,��,�r,�s,�,�,�,�t,�,�u,�v,Ʈ,�,�,��,��,��,�,��,�,�,�,�,�,��,��,��,��,��,��,��,��,�,��,��,��,��,�,�,��,�,��,��,�,��,��,��,�,�,��,��,��,��,��,�,��,��,�@,��,�A,��,��,��,��,��,��,��,��,Ԧ,��,ѱ,��,��,�R,��,¿,��,ʻ,��,��,��,��,פ,��,��,��,��,��,��,��,�S,��,��,��,��,��,�T,��,��,��,�U,�V,��,��,��,��,��,�W,�X,��,ƭ,��,�Y,ɧ,��,��,��,�,��,��,��,��,��,��,��,�Z,��,��,��,��,��,��,��,��,��,��,��,��,³,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�@,��,�,��,�,��,�\,Ÿ,ѻ,�],�,�,�,�,�,Ѽ,�^,��,�_,�,�,ԧ,�`,��,�,�,�,�,�,�a,�b,��,�,��,�c,�,�,��,��,��,��,��,��,��,ȵ,��,��,�d,��,��,�e,��,�f,�g,�h,��,�i,��,��,�j,��,��,��,�k,��,�l,�m,�n,�o,��,��,�p,��,��,��,��,��,��,��,��,�r,ӥ,��,�s,��,�t,��,��,��,��,��,�d,��,��,��,��,��,��,ػ,��,��,��,�,��,��,��,��,��,��,��,��,��,��,��,��,ȣ,��,��,��,��,��"
 t="�f,�c,�h,��,�I,��,��,�z,�G,��,��,��,��,��,�S,�R,��,��,�e,�N,�x,��,��,��,��,�l,��,�I,�y,��,�,̝,�,��,��,�a,��,�H,�C,��,�|,�H,��,��,�},�x,��,�r,��,��,�,��,��,��,��,��,��,�t,��,��,��,��,�w,�N,��,�L,�b,�H,�e,��,��,�S,�~,��,�z,�R,��,��,�z,��,��,��,�A,��,�E,�f,��,��,��,��,��,��,��,��,�h,�m,�P,�d,Ɲ,�B,�F,��,��,��,��,��,܊,�r,�V,�T,�_,�Q,�r,��,�Q,�D,��,�R,�p,��,�C,��,�P,�D,�{,�P,��,��,�,�c,��,��,�t,��,��,�h,�e,�},�q,��,��,��,��,��,��,��,��,��,�k,��,��,��,��,��,��,��,��,��,��,��,�Q,�T,�^,�t,�A,�f,��,�u,�R,�u,�P,�l,�s,��,�S,�d,��,��,��,��,��,��,��,��,�B,�N,��,�P,�h,��,��,�a,�^,�p,�l,׃,��,�B,�~,̖,�U,�\,�n,��,��,��,��,�w,��, ,��,��,�`,��,�I,��,�h,�T,�J,��,��,ԁ,�U,��,��,�z,߸,�j,�y,��,�,��,�},�^,��,��,�W,��,��,��,��,�O,��,�Z,��,��,�r,��,��,�K,��,��,�m,��,�c,�[,��,�D,��,��,��,��,�u,��,��,��,��,��,�o,�F,�@,��,��,��,��,�D,�A,�},��,��,��,��,�K,��,��,��,��,�],��,��,��,��,��,��,��,�s,��,�|,��,��,��,�N,��,�P,�_,��,�|,��,�q,��,��,ԭ,��,��,,��,��,��,̎,��,�},��,�^,�F,�A,�Z,�Y,�J,�^,��,�W,�y,�D,��,��,��,��,��,�K,��,�I,��,��,�D,��,�z,��,��,��,��,��,��,��,��,��,��,�O,�W,�\,��,��,��,��,��,��,�m,��,�e,��,��,��,��,��,��,��,�m,�L,��,��,��,�M,��,��,��,��,��,��,��,�Z,�q,�M,��,��,�s,�S,��,�u,�X,�[,��,�h,�G,�F,�{,�A,��,��,�n,��,��,�M,��,�V,��,��,��,��,�p,�,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�L,��,�K,ô,�V,�f,�c,�],�T,��,��,�R,��,�U,�F,�[,�_,��,��,��,��,��,��,��,��,�w,��,�,��,��,��,��,��,�R,��,��,�n,��,��,�B,�Z,��,�Y,��,��,�z,��,��,��,��,��,��,�Q,��,��,��,��,��,��,��,��,�a,��,�@,��,�K,��,�v,��,�M,��,�T,��,�C,��,�|,�,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�L,��,�U,��,��,�P,�_,��,��,��,��,��,��,�o,��,��,�M,�n,��,��,�r,�Q,��,��,��,��,��,��,��,��,��,��,��,��,��,�D,�],��,��,�p,��,�Q,�v,��,��,��,��,�S,��,��,��,��,��,��,�v,�R,��,��,�y,�z,�d,�[,�u,�P,��,�t,��,�f,�X,�],�x,�\,��,��,��,��,�S,��,�Y,��,��,�o,�f,�r,��,��,��,��,��,�@,�x,��,��,��,��,��,��,��,��,�g,��,�C,��,�s,��,�l,��,��,�q,��,�O,��,��,��,��,��,�g,��,��,��,�n,��,��,�f,�d,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�E,�n,��,��,��,�u,��,��,��,��,��,�z,��,��,��,��,��,�E,��,��,��,��,��,�x,��,��,��,�M,�{,��,��,��,��,��,��,�_,�g,�e,�W,��,�{,��,��,��,��,��,��,��,��,ݞ,��,��,��,��,��,��,��,��,��,��,�h,�@,��,��,�e,��,�],��,�a,�r,�S,��,�t,��,��,��,��,�I,��,�{,�o,�T,�a,��,��,��,��,��,�D,��,�\,�{,��,��,��,��,�y,��,��,�g,�I,��,�G,��,��,��,�T,��,��,��,�Z,�i,��,�u,��,�o,��,��,��,�q,��,��,�Y,�O,�n,�^,�u,��,�O,�c,�B,��,�[,��,��,��,�R,�s,�U,��,�L,��,��,��,�M,�],�V,�E,��,�I,��,��,�E,�u,�t,��,�H,��,�z,��,�|,�l,��,��,��,�`,��,�N,��,�t,��,��,��,�c,��,��,�q,��,�N,�T,��,��,��,��,�Z,�C,�a,��,��,�F,�c,��,��,��,��,��,��,��,��,��,��,��,��,Ȯ,��,�E,�w,�q,�N,��,��,��,��,�M,�{,��,�b,�z,�s,��,�C,�J,�M,�i,؈,�o,�I,�H,�^,�m,��,��,�|,�h,�F,��,�t,�z,�k,�m,��,�c,�q,�\,�I,��,��,��,�a,�v,��,��,�Y,�T,�,��,��,��,��,�X,��,��,�O,��,�,��,��,��,��,�b,�d,�W,�{,�A,��,�B,�V,�D,��,��,��,�T,�c,�a,�`,�],�_,�d,ğ,�},��,��,�K,�},�O,�w,�I,�P,�g,�{,��,��,��,�A,��,�m,��,�C,��,�\,�V,�X,�a,�u,��,��,�^,�Z,�a,�[,�A,��,��,�T,��,��,�o,��,�_,�|,�K,��,�~,�A,��,�L,�Y,�B,�[,��,�\,��,�A,��,�U,�x,�d,��,�N,�e,�Q,�x,�v,��,��,�d,��,�w,�F,�`,�[,�G,�Z,�C,�Q,�],�M,�Q,��,�V,�S,�P,�a,�{,�\,�e,�B,�`,�Y,��,�~,�I,��,��,�U,�j,�D,�X,�j,��,��,��,�t,�@,�h,�f,�[,�e,�,�i,�g,�c,��,�S,�Z,�R,�f,�o,�{,��,�m,�u,�t,�q,�w,�v,�s,��,�w,�k,�o,�x,��,��,��,��,��,��,�V,�{,��,�v,�],��,��,�y,��,��,��,�~,��,��,�C,�X,��,��,�M,��,��,��,�K,�U,�O,�E,�I,�B,�[,��,�H,��,�q,�Y,�f,�@,�x,�W,�L,�o,�k,�{,�j,�^,�g,�y,��,��,��,�C,��,��,�d,�^,��,��,�w,�c,�x,�m,�_,�p,�b,�y,�i,�K,�S,�d,�R,��,�I,�T,�^,�J,�C,�`,�U,�G,�Y,�l,�~,�|,�},��,�|,��,��,��,�Z,�D,��,�E,��,��,��,��,�P,��,��,�|,��,��,��,�N,�`,�d,�b,�p,�\,�c,�p,�r,�O,�V,�_,�~,�z,�w,�t,�s,��,��,�i,��,��,��,�\,�`,�R,�Q,�U,�y,��,�W,�_,�P,�T,�`,�b,�u,�w,�N,�P,�E,�g,�e,,�u,,�@,,,,,,�C,�c,�w,�d,�I,�[,Û,�{,đ,��,�V,�L,�F,Ä,�z,�},Ē,�v,Ě,�X,ē,�L,�_,Ó,�T,Ę,�D,�Z,�s,�|,ā,�t,�e,�v,Ĝ,�N,ݛ,Ŝ,Ş,œ,�A,�D,�W,�H,ˇ,��,�d,�G,ʏ,�J,ɐ,Ȕ,˞,�{,�O,�n,�r,�K,��,�O,�o,�d,�\,�L,��,�O,�G,�],�R,�v,ʁ,ɜ,�w,�C,�j,ʎ,�s,ȝ,��,��,��,�n,�|,�p,�a,�{,ȇ,Ȓ,ˎ,�W,ɉ,�R,ɏ,�P,�n,�W,�@,�~,��,�L,ɔ,�E,�},Ξ,�I,�M,ʒ,�_,�[,�r,ʉ,�Y,�V,�{,�E,�y,ʚ,�v,�,�N,�`,�A,�@,�I,�N,˒,��,�\,̔,�],̓,�x,�A,�l,�m,�r,ϊ,�g,ρ,Λ,�Q,ϖ,͘,�M,Ϡ,�|,�U,�U,͐,�u,·,ϓ,͑,΁,Ϟ,ω,�X,�s,ϐ,�N,ϔ,�Q,�\,�D,�,�,�a,�r,Ж,�\,��,ы,�m,�u,�U,�b,�d,т,ў,�c,ѝ,�M,�@,�h,��,�w,Ҋ,�^,ҍ,Ҏ,Ғ,ҕ,җ,�[,�X,�J,Ҡ,�],�C,�D,�M,�P,�U,�x,�|,�z,ׄ,�u,�`,Ӆ,Ӌ,ӆ,Ӈ,�J,�I,ӓ,ӏ,ӑ,׌,Ә,ә,Ӗ,�h,Ӎ,ӛ,ӕ,�v,�M,֎,�n,Ӡ,�G,�S,Ӟ,Փ,�K,�A,�S,�O,�L,�E,�C,�b,�X,�u,�{,�R,�w,�p,�V,�\,�g,�a,�~,�x,�t,�v,�g,�r,�E,�C,ԇ,ԟ,Ԋ,ԑ,Ԝ,�\,�D,Ԗ,Ԓ,�Q,ԍ,ԏ,Ԏ,ԃ,Ԅ,Պ,ԓ,Ԕ,Ԍ,՟,Ԃ,�p,�],�_,�Z,�V,�`,�a,�T,�d,�N,�f,�b,�O,Ո,�T,Ռ,�Z,�x,Վ,�u,�n,Ն,՘,�l,Ք,�{,�~,Տ,Ձ,�r,Մ,�x,�\,�R,ՙ,�e,�G,�C,�o,�],�^,�@,�I,�X,׋,�J,�O,�V,�B,�i,՛,՚,փ,ו,�q,�x,�{,�r,՞,�t,�k,֔,֙,ֆ,�v,և,�T,�P,�S,׎,�V,�H,ח,�l,�d,׏,�Y,�r,ؐ,ؑ,ؓ,ؒ,ؕ,ؔ,؟,�t,��,�~,؛,�|,؜,؝,ؚ,�H,ُ,�A,؞,�E,�v,�S,�B,�N,�F,�L,�J,�Q,�M,�R,�O,�\,ٗ,�Z,�V,�D,�U,�T,�E,�Y,�W,�B,�g,�c,�l,�d,�x,ـ,�V,�H,�p,�n,�F,�k,�s,�r,�y,ه,و,٘,َ,ٍ,ِ,ّ,�I,ٝ,ٚ,ٛ,٠,�A,�M,�X,�w,�s,څ,ڎ,�O,�S,ۄ,ە,�V,�`,�J,�E,ۋ,�],�Q,�x,�P,ۙ,�W,�U,�b,ۘ,�X,�f,�k,�g,�|,܇,܈,܉,܎,܍,ܐ,�D,ܗ,݆,ܛ,�Z,�M,�V,�_,�S,�T,�W,ܠ,�F,�],�U,�p,�Y,�d,�e,�I,�c,�b,�`,�^,�m,�o,�v,݂,݅,�x,݁,�y,݈,�z,�w,ݏ,ݗ,݋,ݜ,ݔ,�\,�@,ݠ,ݚ,�A,�H,�O,�o,�q,�p,߅,�|,�_,�w,�^,�~,�\,߀,�@,�M,�h,�`,�B,�t,߃,ޟ,�E,�m,�x,�d,�f,ߊ,߉,�z,�b,��,��,�w,�],�u,��,��,�d,�S,�P,��,��,�i,�B,�y,��,�j,�w,�u,�,�,�,�,�Y,��,�b,�,�Y,�,�,�,�,�,�,�,�Q,�T,�A,�,�l,�C,�,�{,�S,�,�O,�],�},�b,�,�g,�n,�R,�c,�^,�,�k,�j,�,�J,�x,�u,�^,�,�[,�,�^,�o,�Z,�,�X,�`,�Q,�,��,�,�O,�,�,�X,�,�f,�g,�,�,�,�F,�K,�,�p,�U,�T,�,�C,�B,�G,�,�,�I,�o,�D,�,�s,�,�E,�B,�,�e,�y,�t,�,�K,�~,�X,�H,�,�z,�,�,�,�b,�A,�,�f,�,�|,�x,�,�t,�,�P,�C,�q,�,�P,�|,�|,�@,�y,�,�T,�,�,�o,�n,�,�,�H,�N,�i,�,�{,�z,�,�,�~,�n,�S,�s,�h,�\,�,�,�,�J,�R,�Z,�u,�|,�H,�,�N,�,�e,�^,�Q,�W,�u,�,�K,�_,�a,�d,�,�N,�F,�\,�e,�v,�,�x,�,�U,�V,�I,�,�i,�O,�,�},�|,�I,�J,�,�,�@,�R,�,�},�,�D,�X,�,�V,�U,�t,�,�[,�,�,�n,�k,�,�,�,�,�,�y,�,�^,�,�,�\,�g,�S,�M,�N,�,�a,�O,�R,�C,�,�,�B,�,�,�,�h,�u,�,�|,�,�,�j,�,�Z,�D,�G,�C,�,�O,�d,�s,�n,�,�,�L,�T,�V,�W,�Z,�\,�],��,�J,�c,�,�e,�b,�g,�h,�`,��,�l,�[,�|,,�Y,�},�,�G,�y,�w,�u,�,�b,�,�,�A,�,�,�,�],�,�,�,�,�U,�@,�,�T,�,�,�H,�D,�F,�I,�R,�X,�,�,�,�,�A,�H,�,�],�,�,�,�,�E,�U,�S,�[,�`,�h,�y,�r,ׇ,�Z,�F,�V,�q,�\,�n,�o,�v,�^,�X,�d,�x,�f,�g,�h,�n,�t,�y,�w,�,�,�,�,�,�,�,�,�,�B,�,�D,��,�C,�,�@,�A,�B,�I,�H,�i,�R,�a,�c,�M,�},��,�W,�U,�l,�_,�j,�h,�e,�f,�w,�},�,�,�,�,�~,�D,�,�,�,�,�h,�,�,�A,�E,�L,�^,�Q,�R,�S,�Z,�\,�`,�_,�d,�h,�j,�j,�w,��,�,�},��,�,�h,�,�q,�,�,�,�,�,�T,�,�,�,�,�,�D,��,�A,�,�E,�,�F,�,�G,�L,�I,�N,�H,�K,�R,�Q,�W,�^,�l,��,�k,�t,�,�v,�x,�o,�s,�},�~,�z,��,��,�,�R,�S,�W,�Z,�Y,�,�_,�g,�H,�z,�,�,�,�x,�|,�v,�,�w,�{,�A,�~,�,�R,�,�,�,�,�,�,�Q,�P,�G,�,�H,�,�E,�U,�T,�S,�K,�R,�,�,�_,�s,�j,�},�\,�,�t,�q,�~,�,�,�,�,�E,�K,�L,�J,�t,�y,�x,�W,�|,�u,�~,�,�,��,�,��,��,��,�E,�G,�T,�|,�O,�W,�V,�N,�U,�c,�Q,�T,�q,�^,�w,�n,�b,�j,�f,�`,�d,�q,�o,�r,�~,��,�\,��,�~,��,��,��,��,��,��,��,��,�z,�a,��,��,�N,��,�O,�E,�H,�K,�A,�F,�T,��,�L,�Y,�X,��,�a,�l,�s,�l,�[,��,�g,�w,�{,�q,�v,�m,�e,�F,�c,��,��,��,��,��,��,��,��,��,�B,�L,�M,��,��,�I,�@,�Z,�X,�[,�V,�s,�h,�k,�g,�B,�F,�u,�S,�Q,�O,�t,�f,�I,�d,�c,��,��,�R,��,�{,��,�o,�|,�z,�x,��,�r,��,�v,��,��,��,��,�@,��,�[,��,�M,�P,�Z,�N,�],�Z,�O,��,�Y,�^,�o,��,�g,�A,�l,�i,�k,��,��,�t,��,��,��,��,�X,��,�\,�B,�F,�g,�_,�O,�V,�W,�^,�Y,�Q,�s,�W,�p,�w,��,��,��,��,��,�D,��,�I,�L,�X,�U,�z,��,��,�S,�Z,�s,�t,�o,�w,�x,�{,��,�,�B,�O,�R,�W,�X,�Z,�[,�],�e,�g,�_,�f,�b,�l,�r,�p,�x,�},��,��,��,��"
c=split(s,",")
d=split(t,",")
for i=0 to 2555
content=replace(content,c(i),d(i))
next
GbToBig=content
end function
%>
///class to store terms and condition or privacy policy details data
///
/// See also:
///
/// * [TermsPage]
/// * [TermsDetailPage]
class Term {
  ///title of term or privacy policy in [TermsDetailPage]
  final String title;

  ///detail of term or privacy policy in [TermsDetailPage]
  final String detail;

  const Term(this.title, this.detail);
}

# Standard permission sets for projects

## STLAStandardRO permission set

**This permission set allows DevOps users to access in read-only to all AWS services excluding sensitive ones.** 

This can be granted to all project team members in all accounts.

The attached AWS policies for `STLAStandardRO` are the following:

* arn:aws:iam::aws:policy/ViewOnlyAccess

The inline policy for this permission set is:

* STLAStandardDeny.json

## STLAStandardRW permission set

**This permission set allows DevOps users to access in read-write to selected AWS services.**

This can be granted to:

* Project developers in non-production accounts
* Project operations in all accounts

The AWS attached policies for `STLAStandardRW` are the following:

* arn:aws:iam::aws:policy/ViewOnlyAccess
* arn:aws:iam::aws:policy/AWSBackupOperatorAccess

The inline policy for this permission set is:

* STLAStandardAccess.json

## STLAStandardManager permission set

**This permission set allows project lead/managers to access in read-write to selected AWS services.**

This can be granted to project lead/managers in all accounts.

The attached policies for `STLAStandardManager` are the following:

* arn:aws:iam::aws:policy/ViewOnlyAccess
* arn:aws:iam::aws:policy/AWSBackupFullAccess

The inline policy for this permission set is:

* STLAStandardManager.json

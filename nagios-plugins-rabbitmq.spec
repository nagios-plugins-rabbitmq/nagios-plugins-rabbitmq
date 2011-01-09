Name:           nagios-plugins-rabbitmq
Version:        1.0.0
Release:        1%{?dist}
Summary:        Nagios checks for RabbitMQ

Group:          Applications/System
License:        ASL 2.0
URL:            http://github.com/jamesc/nagios-plugins-rabbitmq
Source0:        nagios-plugins-rabbitmq-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
# Correct for lots of packages, other common choices include eg. Module::Build
BuildRequires:  perl(Module::Build)
Requires:  perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))
Requires: perl(JSON)
Requires: perl(Nagios::Plugins)
Requires: perl(LWP::UserAgent)
Requires: perl(Getopt::Long)
Requires: perl(Pod::Usage)

%{?perl_default_filter}

%description
Nagios checks for RabbitMQ messaging server.

These use the RabbitMQ management interface for gathering various
information about the server

%prep
%setup -q


%build
# Remove OPTIMIZE=... from noarch packages (unneeded)
%{__perl} Build.pl --installdirs=vendor OPTIMIZE="$RPM_OPT_FLAGS"
Build 


%install
rm -rf $RPM_BUILD_ROOT
Build pure_install --destdir=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} ';'
# Remove the next line from noarch packages (unneeded)
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null ';'
%{_fixperms} $RPM_BUILD_ROOT/*


%check
Build test


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc LICENSE.txt README.md
%{_bindir}/*
%{_mandir}/man1/*.1*


%changelog
* Sun Jan 09 2010 James Casey <jamesc.000@gmail.com> 1.0.0-1
- Initial version


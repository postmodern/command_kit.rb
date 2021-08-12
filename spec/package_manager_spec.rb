require 'spec_helper'
require 'command_kit/package_manager'

describe CommandKit::PackageManager do
  module TestPackageManager
    class TestCommand
      include CommandKit::PackageManager
    end
  end

  let(:command_class) { TestPackageManager::TestCommand }
  subject { command_class.new }

  describe "#initialize" do
    context "when no package_manager: keyword is given" do
      context "and when the OS is macOS" do
        subject { command_class.new(os: :macos) }

        context "and the brew command is detected" do
          before do
            expect_any_instance_of(command_class).to receive(:command_installed?).with('brew').and_return(true)
          end

          it "must set #package_manager to :brew" do
            expect(subject.package_manager).to eq(:brew)
          end
        end

        context "but the port command is detected instead" do
          before do
            expect_any_instance_of(command_class).to receive(:command_installed?).with('brew').and_return(false)
            expect_any_instance_of(command_class).to receive(:command_installed?).with('port').and_return(true)
          end

          it "must set #package_manager to :port" do
            expect(subject.package_manager).to eq(:port)
          end
        end

        context "if no package manager command can be detected" do
          before do
            expect_any_instance_of(command_class).to receive(:command_installed?).with('brew').and_return(false)
            expect_any_instance_of(command_class).to receive(:command_installed?).with('port').and_return(false)
          end

          it "must set #package_manager to nil" do
            expect(subject.package_manager).to be(nil)
          end
        end
      end

      context "and when the OS is Linux" do
        context "and the Linux Distro is RedHat" do
          subject { command_class.new(os: :linux, linux_distro: :redhat) }

          context "and the dnf command is detected" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('dnf').and_return(true)
            end

            it "must set #package_manager to :dnf" do
              expect(subject.package_manager).to eq(:dnf)
            end
          end

          context "but the yum command is detected instead" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('dnf').and_return(false)
              expect_any_instance_of(command_class).to receive(:command_installed?).with('yum').and_return(true)
            end

            it "must set #package_manager to :yum" do
              expect(subject.package_manager).to eq(:yum)
            end
          end

          context "if no package manager command can be detected" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('dnf').and_return(false)
              expect_any_instance_of(command_class).to receive(:command_installed?).with('yum').and_return(false)
            end

            it "must set #package_manager to nil" do
              expect(subject.package_manager).to be(nil)
            end
          end
        end

        context "and the Linux Distro is Debian" do
          subject { command_class.new(os: :linux, linux_distro: :debian) }

          context "and the apt command is detected" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('apt').and_return(true)
            end

            it "must set #package_manager to :apt" do
              expect(subject.package_manager).to eq(:apt)
            end
          end

          context "if no package manager command can be detected" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('apt').and_return(false)
            end

            it "must set #package_manager to nil" do
              expect(subject.package_manager).to be(nil)
            end
          end
        end

        context "and the Linux Distro is SuSe" do
          subject { command_class.new(os: :linux, linux_distro: :suse) }

          context "and the zypper command is detected" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('zypper').and_return(true)
            end

            it "must set #package_manager to :zypper" do
              expect(subject.package_manager).to eq(:zypper)
            end
          end

          context "if no package manager command can be detected" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('zypper').and_return(false)
            end

            it "must set #package_manager to nil" do
              expect(subject.package_manager).to be(nil)
            end
          end
        end

        context "and the Linux Distro is Arch" do
          subject { command_class.new(os: :linux, linux_distro: :arch) }

          context "and the pacman command is detected" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('pacman').and_return(true)
            end

            it "must set #package_manager to :pacman" do
              expect(subject.package_manager).to eq(:pacman)
            end
          end

          context "if no package manager command can be detected" do
            before do
              expect_any_instance_of(command_class).to receive(:command_installed?).with('pacman').and_return(false)
            end

            it "must set #package_manager to nil" do
              expect(subject.package_manager).to be(nil)
            end
          end
        end
      end

      context "and when the OS is FreeBSD" do
        subject { command_class.new(os: :freebsd) }

        context "and the pkg command is detected" do
          before do
            expect_any_instance_of(command_class).to receive(:command_installed?).with('pkg').and_return(true)
          end

          it "must set #package_manager to :pkg" do
            expect(subject.package_manager).to eq(:pkg)
          end
        end

        context "if no package manager command can be detected" do
          before do
            expect_any_instance_of(command_class).to receive(:command_installed?).with('pkg').and_return(false)
          end

          it "must set #package_manager to nil" do
            expect(subject.package_manager).to be(nil)
          end
        end
      end

      context "and when the OS is OpenBSD" do
        subject { command_class.new(os: :openbsd) }

        context "and the pkg command is detected" do
          before do
            expect_any_instance_of(command_class).to receive(:command_installed?).with('pkg_add').and_return(true)
          end

          it "must set #package_manager to :pkg_add" do
            expect(subject.package_manager).to eq(:pkg_add)
          end
        end

        context "if no package manager command can be detected" do
          before do
            expect_any_instance_of(command_class).to receive(:command_installed?).with('pkg_add').and_return(false)
          end

          it "must set #package_manager to nil" do
            expect(subject.package_manager).to be(nil)
          end
        end
      end

      context "but the OS could not be determined" do
        subject { command_class.new(os: nil) }

        it "must set #package_manager to nil" do
          expect(subject.package_manager).to be(nil)
        end
      end
    end

    context "when given package_manager: keyword" do
      let(:package_manager) { :pkg_add }

      subject { command_class.new(package_manager: package_manager) }

      it "must set #package_manager" do
        expect(subject.package_manager).to eq(package_manager)
      end
    end
  end

  describe "#install_packages" do
    context "when the #package_manager is :apt" do
      subject { command_class.new(package_manager: :apt) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        it "must run `sudo apt install ...` with the package names" do
          expect(subject).to receive(:sudo).with("apt","install",*packages)

          subject.install_packages(*packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo apt install -y ...` with the package names" do
            expect(subject).to receive(:sudo).with(
              "apt", "install", "-y", *packages
            )

            subject.install_packages(*packages, yes: true)
          end
        end
      end

      context "and when the apt: keyword argument is given" do
        let(:apt_packages) { ["foo", "bar", "baz"] }

        it "must run `sudo apt install ...` with the package names" do
          expect(subject).to receive(:sudo).with("apt","install",*apt_packages)

          subject.install_packages(apt: apt_packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo apt install -y ...` with the package names" do
            expect(subject).to receive(:sudo).with(
              "apt", "install", "-y", *apt_packages
            )

            subject.install_packages(apt: apt_packages, yes: true)
          end
        end
      end

      context "and when both arguments and apt: keyword argument are given" do
        let(:packages) { ["foo", "bar"] }
        let(:apt_packages) { ["baz"] }

        it "must run `sudo apt install ...` with the combined package names" do
          expect(subject).to receive(:sudo).with(
            "apt", "install", *(packages + apt_packages)
          )

          subject.install_packages(*packages, apt: apt_packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo apt install -y ...` with the combined package names" do
            expect(subject).to receive(:sudo).with(
              "apt", "install", "-y", *(packages + apt_packages)
            )

            subject.install_packages(*packages, apt: apt_packages, yes: true)
          end
        end
      end
    end

    context "when the #package_manager is :brew" do
      subject { command_class.new(package_manager: :brew) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        it "must run `brew install ...` with the package names" do
          expect(subject).to receive(:system).with("brew","install",*packages)

          subject.install_packages(*packages)
        end
      end

      context "and when the brew: keyword argument is given" do
        let(:brew_packages) { ["foo", "bar", "baz"] }

        it "must run `brew install ...` with the package names" do
          expect(subject).to receive(:system).with(
            "brew", "install", *brew_packages
          )

          subject.install_packages(brew: brew_packages)
        end
      end

      context "and when both arguments and brew: keyword argument are given" do
        let(:packages) { ["foo", "bar"] }
        let(:brew_packages) { ["baz"] }

        it "must run `brew install ...` with the combined package names" do
          expect(subject).to receive(:system).with(
            "brew", "install", *(packages + brew_packages)
          )

          subject.install_packages(*packages, brew: brew_packages)
        end
      end
    end

    context "when the #package_manager is :dnf" do
      subject { command_class.new(package_manager: :dnf) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        it "must run `sudo dnf install ...` with the package names" do
          expect(subject).to receive(:sudo).with("dnf","install",*packages)

          subject.install_packages(*packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo dnf install -y ...` with the package names" do
            expect(subject).to receive(:sudo).with(
              "dnf", "install", "-y", *packages
            )

            subject.install_packages(*packages, yes: true)
          end
        end
      end

      context "and when the dnf: keyword argument is given" do
        let(:dnf_packages) { ["foo", "bar", "baz"] }

        it "must run `sudo dnf install ...` with the package names" do
          expect(subject).to receive(:sudo).with("dnf","install",*dnf_packages)

          subject.install_packages(dnf: dnf_packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo dnf install -y ...` with the package names" do
            expect(subject).to receive(:sudo).with(
              "dnf", "install", "-y", *dnf_packages
            )

            subject.install_packages(dnf: dnf_packages, yes: true)
          end
        end
      end

      context "and when both arguments and dnf: keyword argument are given" do
        let(:packages) { ["foo", "bar"] }
        let(:dnf_packages) { ["baz"] }

        it "must run `sudo dnf install ...` with the combined package names" do
          expect(subject).to receive(:sudo).with(
            "dnf", "install", *(packages + dnf_packages)
          )

          subject.install_packages(*packages, dnf: dnf_packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo dnf install -y ...` with the combined package names" do
            expect(subject).to receive(:sudo).with(
              "dnf", "install", "-y", *(packages + dnf_packages)
            )

            subject.install_packages(*packages, dnf: dnf_packages, yes: true)
          end
        end
      end
    end

    context "when the #package_manager is :yum" do
      subject { command_class.new(package_manager: :yum) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        it "must run `sudo yum install ...` with the package names" do
          expect(subject).to receive(:sudo).with("yum","install",*packages)

          subject.install_packages(*packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo yum install -y ...` with the package names" do
            expect(subject).to receive(:sudo).with(
              "yum", "install", "-y", *packages
            )

            subject.install_packages(*packages, yes: true)
          end
        end
      end

      context "and when the yum: keyword argument is given" do
        let(:yum_packages) { ["foo", "bar", "baz"] }

        it "must run `sudo yum install ...` with the package names" do
          expect(subject).to receive(:sudo).with("yum","install",*yum_packages)

          subject.install_packages(yum: yum_packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo yum install -y ...` with the package names" do
            expect(subject).to receive(:sudo).with(
              "yum", "install", "-y", *yum_packages
            )

            subject.install_packages(yum: yum_packages, yes: true)
          end
        end
      end

      context "and when both arguments and yum: keyword argument are given" do
        let(:packages) { ["foo", "bar"] }
        let(:yum_packages) { ["baz"] }

        it "must run `sudo yum install ...` with the combined package names" do
          expect(subject).to receive(:sudo).with(
            "yum", "install", *(packages + yum_packages)
          )

          subject.install_packages(*packages, yum: yum_packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo yum install -y ...` with the combined package names" do
            expect(subject).to receive(:sudo).with(
              "yum", "install", "-y", *(packages + yum_packages)
            )

            subject.install_packages(*packages, yum: yum_packages, yes: true)
          end
        end
      end
    end

    context "when the #package_manager is :pacman" do
      subject { command_class.new(package_manager: :pacman) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        context "when none of the packages are already installed" do
          before do
            allow(subject).to receive(:`).with("pacman -T #{packages.join(' ')}").and_return(packages.join($/))
          end

          it "must run `sudo pacman -T ...` then `sudo pacman -S ...`" do
            expect(subject).to receive(:sudo).with("pacman","-S",*packages)

            subject.install_packages(*packages)
          end
        end

        context "when some of the packages have already been installed" do
          let(:missing_packages) { ["foo", "baz"] }

          before do
            allow(subject).to receive(:`).with("pacman -T #{packages.join(' ')}").and_return(missing_packages.join($/))
          end

          it "must omit them from the `sudo pacman -S ...` command" do
            expect(subject).to receive(:sudo).with("pacman","-S",*missing_packages)

            subject.install_packages(*packages)
          end
        end

        context "when all packages have already been installed" do
          before do
            allow(subject).to receive(:`).with("pacman -T #{packages.join(' ')}").and_return($/)
          end

          it "must return true" do
            expect(subject.install_packages(*packages)).to be(true)
          end
        end
      end

      context "and when the pacman: keyword argument is given" do
        let(:pacman_packages) { ["foo", "bar", "baz"] }

        context "when none of the packages are already installed" do
          before do
            allow(subject).to receive(:`).with(
              "pacman -T #{pacman_packages.join(' ')}"
            ).and_return(pacman_packages.join($/))
          end

          it "must run `sudo pacman -T ...` then `sudo pacman -S ...`" do
            expect(subject).to receive(:sudo).with(
              "pacman", "-S", *pacman_packages
            )

            subject.install_packages(pacman: pacman_packages)
          end
        end

        context "when some of the packages have already been installed" do
          let(:missing_packages) { ["foo", "baz"] }

          before do
            allow(subject).to receive(:`).with(
              "pacman -T #{pacman_packages.join(' ')}"
            ).and_return(missing_packages.join($/))
          end

          it "must omit them from the `sudo pacman -S ...` command" do
            expect(subject).to receive(:sudo).with(
              "pacman", "-S", *missing_packages
            )

            subject.install_packages(pacman: pacman_packages)
          end
        end

        context "when all packages have already been installed" do
          before do
            allow(subject).to receive(:`).with(
              "pacman -T #{pacman_packages.join(' ')}"
            ).and_return($/)
          end

          it "must return true" do
            expect(subject.install_packages(
              pacman: pacman_packages
            )).to be(true)
          end
        end
      end

      context "and when both arguments and pacman: keyword argument are given" do
        let(:packages)        { ["foo", "baz"] }
        let(:pacman_packages) { ["bar"]        }

        context "when none of the packages are already installed" do
          before do
            allow(subject).to receive(:`).with(
              "pacman -T #{(packages + pacman_packages).join(' ')}"
            ).and_return((packages + pacman_packages).join($/))
          end

          it "must run `sudo pacman -T ...` then `sudo pacman -S ...`" do
            expect(subject).to receive(:sudo).with(
              "pacman", "-S", *(packages + pacman_packages)
            )

            subject.install_packages(*packages, pacman: pacman_packages)
          end
        end

        context "when some of the packages have already been installed" do
          let(:missing_packages) { ["foo", "baz"] }

          before do
            allow(subject).to receive(:`).with(
              "pacman -T #{(packages + pacman_packages).join(' ')}"
            ).and_return(missing_packages.join($/))
          end

          it "must omit them from the `sudo pacman -S ...` command" do
            expect(subject).to receive(:sudo).with(
              "pacman", "-S", *missing_packages
            )

            subject.install_packages(*packages, pacman: pacman_packages)
          end
        end

        context "when all packages have already been installed" do
          before do
            allow(subject).to receive(:`).with(
              "pacman -T #{(packages + pacman_packages).join(' ')}"
            ).and_return($/)
          end

          it "must return true" do
            expect(subject.install_packages(
              *packages, pacman: pacman_packages
            )).to be(true)
          end
        end
      end
    end

    context "when the #package_manager is :pkg" do
      subject { command_class.new(package_manager: :pkg) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        it "must run `sudo pkg install ...` with the package names" do
          expect(subject).to receive(:sudo).with("pkg","install",*packages)

          subject.install_packages(*packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo pkg install -y ...` with the package names" do
            expect(subject).to receive(:sudo).with(
              "pkg", "install", "-y", *packages
            )

            subject.install_packages(*packages, yes: true)
          end
        end
      end

      context "and when the pkg: keyword argument is given" do
        let(:pkg_packages) { ["foo", "bar", "baz"] }

        it "must run `sudo pkg install ...` with the package names" do
          expect(subject).to receive(:sudo).with("pkg","install",*pkg_packages)

          subject.install_packages(pkg: pkg_packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo pkg install -y ...` with the package names" do
            expect(subject).to receive(:sudo).with(
              "pkg", "install", "-y", *pkg_packages
            )

            subject.install_packages(pkg: pkg_packages, yes: true)
          end
        end
      end

      context "and when both arguments and pkg: keyword argument are given" do
        let(:packages) { ["foo", "bar"] }
        let(:pkg_packages) { ["baz"] }

        it "must run `sudo pkg install ...` with the combined package names" do
          expect(subject).to receive(:sudo).with(
            "pkg", "install", *(packages + pkg_packages)
          )

          subject.install_packages(*packages, pkg: pkg_packages)
        end

        context "and the yes: keyword argument is given" do
          it "must run `sudo pkg install -y ...` with the combined package names" do
            expect(subject).to receive(:sudo).with(
              "pkg", "install", "-y", *(packages + pkg_packages)
            )

            subject.install_packages(*packages, pkg: pkg_packages, yes: true)
          end
        end
      end
    end

    context "when the #package_manager is :pkg_add" do
      subject { command_class.new(package_manager: :pkg_add) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        it "must run `pkg_add ...` with the package names" do
          expect(subject).to receive(:sudo).with("pkg_add",*packages)

          subject.install_packages(*packages)
        end
      end

      context "and when the pkg_add: keyword argument is given" do
        let(:pkg_add_packages) { ["foo", "bar", "baz"] }

        it "must run `pkg_add ...` with the package names" do
          expect(subject).to receive(:sudo).with(
            "pkg_add", *pkg_add_packages
          )

          subject.install_packages(pkg_add: pkg_add_packages)
        end
      end

      context "and when both arguments and pkg_add: keyword argument are given" do
        let(:packages) { ["foo", "bar"] }
        let(:pkg_add_packages) { ["baz"] }

        it "must run `pkg_add ...` with the combined package names" do
          expect(subject).to receive(:sudo).with(
            "pkg_add", *(packages + pkg_add_packages)
          )

          subject.install_packages(*packages, pkg_add: pkg_add_packages)
        end
      end
    end

    context "when the #package_manager is :port" do
      subject { command_class.new(package_manager: :port) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        it "must run `port install ...` with the package names" do
          expect(subject).to receive(:sudo).with("port","install",*packages)

          subject.install_packages(*packages)
        end
      end

      context "and when the port: keyword argument is given" do
        let(:port_packages) { ["foo", "bar", "baz"] }

        it "must run `port install ...` with the package names" do
          expect(subject).to receive(:sudo).with(
            "port", "install", *port_packages
          )

          subject.install_packages(port: port_packages)
        end
      end

      context "and when both arguments and port: keyword argument are given" do
        let(:packages) { ["foo", "bar"] }
        let(:port_packages) { ["baz"] }

        it "must run `port install ...` with the combined package names" do
          expect(subject).to receive(:sudo).with(
            "port", "install", *(packages + port_packages)
          )

          subject.install_packages(*packages, port: port_packages)
        end
      end
    end

    context "when the #package_manager is :zypper" do
      subject { command_class.new(package_manager: :zypper) }

      context "and when arguments are given" do
        let(:packages) { ["foo", "bar", "baz"] }

        it "must run `zypper -n install -l ...` with the package names" do
          expect(subject).to receive(:sudo).with(
            "zypper", "-n", "in", "-l", *packages
          )

          subject.install_packages(*packages)
        end
      end

      context "and when the zypper: keyword argument is given" do
        let(:zypper_packages) { ["foo", "bar", "baz"] }

        it "must run `zypper install ...` with the package names" do
          expect(subject).to receive(:sudo).with(
            "zypper", "-n", "in", "-l", *zypper_packages
          )

          subject.install_packages(zypper: zypper_packages)
        end
      end

      context "and when both arguments and zypper: keyword argument are given" do
        let(:packages) { ["foo", "bar"] }
        let(:zypper_packages) { ["baz"] }

        it "must run `zypper install ...` with the combined package names" do
          expect(subject).to receive(:sudo).with(
            "zypper", "-n", "in", "-l", *(packages + zypper_packages)
          )

          subject.install_packages(*packages, zypper: zypper_packages)
        end
      end
    end
  end
end

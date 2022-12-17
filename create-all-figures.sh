
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi


cd "$(dirname "$0")/scripts"

main() {
    if ! command -v Rscript >/dev/null 2>&1; then
        echo "Rscript is not installed"
    fi
    echo "Generating Figure 1"
    Rscript Fig01-BV-frequency-response.R

    echo "Generating Figure 3"
    Rscript Fig03-meteo-conditions.R

    echo "Generating Figure 5"
    Rscript Fig05-data-choice.R

    echo "Generating Figure 6"
    Rscript Fig06-how-STEA-works.R

    echo "Generating Figure 7"
    Rscript Fig07-water-vapour-correction.R

    echo "Generating Figure 8"
    Rscript Fig08-STEA-EC-intercomparison.R

    echo "Generating Figure 9"
    Rscript Fig09-STEA-EC-cummulative.R

    echo "Generating Figure 10"
    Rscript Fig10-empirical-BV-correction.R

}

main "$@"





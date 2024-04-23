import { css } from "uebersicht";

export const command = "/usr/local/bin/docker ps";
export const refreshFrequency = 5000;

export const className = css`
  font-family: "IBM Plex Mono";
  color: white;
  div#root {
    position: absolute;
    top: 24px;
    left: 24px;
    padding: 12px;
    background: #000;
    border-radius: 12px;

    header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 12px;
      #updated-at {
        opacity: 0.5;
      }
    }

    table {
      font-size: 12px;
      th {
        min-width: 140px;
        text-align: left;
        color: #0db7ed;
      }
      tr {
        .status {
          display: inline-block;
          width: 8px;
          height: 8px;
          border-radius: 50%;
          margin-right: 8px;
        }
      }
    }
  }
`;

/**
 * @param {string} output
 * @returns {{id: string, image: string, command: string, created: string, status: string, ports: string, names: string}[]}}
 */
const parseDockerProcess = (output) => {
  const [headerLine, ...lines] = output.split("\n");
  const header = headerLine.split(/\s{2,}/);
  const body = lines
    .filter((line) => line.trim().length > 0)
    .map((line) => {
      const values = line.split(/\s{2,}/);
      return values.reduce((acc, value, index) => {
        const key = header[index];
        acc[key] = value;
        return acc;
      }, {});
    });
  return body;
};

const keys = ["CONTAINER ID", "NAMES", "IMAGE", "STATUS", "PORTS"];

export const render = ({ output }) => {
  const dockerProcesses = parseDockerProcess(output);
  return (
    <div id="root">
      <header>
        <div id="docker">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            aria-label="Docker"
            role="img"
            viewBox="0 0 512 512"
            style={{
              width: "24px",
              height: "24px",
            }}
          >
            <path
              stroke="#0db7ed"
              stroke-width="38"
              d="M296 226h42m-92 0h42m-91 0h42m-91 0h41m-91 0h42m8-46h41m8 0h42m7 0h42m-42-46h42"
            />
            <path
              fill="#0db7ed"
              d="m472 228s-18-17-55-11c-4-29-35-46-35-46s-29 35-8 74c-6 3-16 7-31 7H68c-5 19-5 145 133 145 99 0 173-46 208-130 52 4 63-39 63-39"
            />
          </svg>
        </div>
        <div id="updated-at">
          last updated at {new Date().toLocaleTimeString()}
        </div>
      </header>
      <table>
        <thead>
          <tr>
            {keys.map((key) => (
              <th key={key}>{key.toLocaleLowerCase()}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {dockerProcesses.map((process) => (
            <tr key={process.id}>
              {keys.map((key) => {
                let content = process[key];
                if (key === "PORTS") {
                  const entries = content.split(", ");
                  const ports = entries.map((entry) => {
                    const [container, host] = entry.split("->");
                    const hostPort = host.split("/")[0];
                    const containerPort = container.match(/.+:(\d+)/)[1];
                    return `${containerPort}_${hostPort}`;
                  });
                  const uniquePorts = Array.from(new Set(ports));
                  content = uniquePorts.map((portmap) => {
                    const [containerPort, hostPort] = portmap.split("_");
                    return (
                      <div key={portmap}>
                        <span>{hostPort}</span>
                        <span
                          style={{
                            opacity: 0.5,
                            margin: "0 8px",
                          }}
                        >
                          →
                        </span>
                        <span>{containerPort}</span>
                      </div>
                    );
                  });
                }
                if (key === "STATUS") {
                  const healthCheck = content.match(/(.+) \((.+)\)/);
                  let statusColor = "#ccc";
                  if (healthCheck) {
                    switch (healthCheck[2]) {
                      case "healthy":
                        statusColor = "#0db7ed";
                        break;
                      case "unhealthy":
                        statusColor = "#ff3860";
                        break;
                      case "health: starting":
                        statusColor = "#ffdd57";
                        break;
                      default:
                        break;
                    }
                    content = [
                      <span
                        key="status"
                        className="status"
                        style={{
                          background: statusColor,
                        }}
                      />,
                      <span key="uptime">{healthCheck[1]}</span>,
                    ];
                  } else {
                    content = [
                      <span
                        key="status"
                        className="status"
                        style={{
                          background: statusColor,
                        }}
                      />,
                      <span key="uptime">{content}</span>,
                    ];
                  }
                }
                return <td key={key}>{content}</td>;
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

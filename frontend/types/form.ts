export type FormData = {
    vztah: string;
    vek: string;
    pohlavi: string;
    sobestacnost: string;
    prispevek: string;
    trvani: string;
    bydleni: string;
    psc: string;
    pomoc: string[];
    prace: string;
    trapi: string[];
};

export const initialData: FormData = {
    vztah: "",
    vek: "",
    pohlavi: "",
    sobestacnost: "",
    prispevek: "",
    trvani: "",
    bydleni: "",
    psc: "",
    pomoc: [],
    prace: "",
    trapi: [],
};
